package com.bjsxt.service.impl;

import cn.hutool.core.util.RandomUtil;
import com.alicp.jetcache.Cache;
import com.alicp.jetcache.anno.CacheType;
import com.alicp.jetcache.anno.CreateCache;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bjsxt.domain.Account;
import com.bjsxt.domain.CashWithdrawAuditRecord;
import com.bjsxt.domain.CashWithdrawals;
import com.bjsxt.domain.Config;
import com.bjsxt.dto.UserBankDto;
import com.bjsxt.dto.UserDto;
import com.bjsxt.feign.UserBankServiceFeign;
import com.bjsxt.feign.UserServiceFeign;
import com.bjsxt.mapper.CashWithdrawAuditRecordMapper;
import com.bjsxt.mapper.CashWithdrawalsMapper;
import com.bjsxt.model.CashSellParam;
import com.bjsxt.service.AccountService;
import com.bjsxt.service.CashWithdrawalsService;
import com.bjsxt.service.ConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@Service
public class CashWithdrawalsServiceImpl extends ServiceImpl<CashWithdrawalsMapper, CashWithdrawals> implements CashWithdrawalsService {


    @Autowired
    private UserServiceFeign userServiceFeign;

    @Autowired
    private ConfigService configService;


    @Autowired
    private StringRedisTemplate redisTemplate;


    @Autowired
    private UserBankServiceFeign userBankServiceFeign;


    @Autowired
    private AccountService accountService;


    @Autowired
    private CashWithdrawAuditRecordMapper cashWithdrawAuditRecordMapper;


    @CreateCache(name = "CASH_WITHDRAWALS_LOCK:", expire = 100, timeUnit = TimeUnit.SECONDS, cacheType = CacheType.BOTH)
    private Cache<String, String> lock;


    /**
     * 提现记录的查询
     *
     * @param page      分页数据
     * @param userId    用户的id
     * @param userName  用户的名称
     * @param mobile    用户的手机号
     * @param status    提现的状态
     * @param numMin    提现的最小金额
     * @param numMax    提现的最大金额
     * @param startTime 提现的开始时间
     * @param endTime   提现的截至时间
     * @return
     */
    @Override
    public Page<CashWithdrawals> findByPage(Page<CashWithdrawals> page, Long userId, String userName, String mobile, Byte status, String numMin, String numMax, String startTime, String endTime) {
        // 有用户的信息时
        Map<Long, UserDto> basicUsers = null;
        LambdaQueryWrapper<CashWithdrawals> cashWithdrawalsLambdaQueryWrapper = new LambdaQueryWrapper<>();
        if (userId != null || !StringUtils.isEmpty(userName) || !StringUtils.isEmpty(mobile)) {
            basicUsers = userServiceFeign.getBasicUsers(userId == null ? null : Arrays.asList(userId), userName, mobile);
            if (CollectionUtils.isEmpty(basicUsers)) {
                return page;
            }
            Set<Long> userIds = basicUsers.keySet();
            cashWithdrawalsLambdaQueryWrapper.in(CashWithdrawals::getUserId, userIds);
        }
        // 其他的查询信息
        cashWithdrawalsLambdaQueryWrapper.eq(status != null, CashWithdrawals::getStatus, status)
                .between(
                        !(StringUtils.isEmpty(numMin) || StringUtils.isEmpty(numMax)),
                        CashWithdrawals::getNum,
                        new BigDecimal(StringUtils.isEmpty(numMin) ? "0" : numMin),
                        new BigDecimal(StringUtils.isEmpty(numMax) ? "0" : numMax)
                )
                .between(
                        !(StringUtils.isEmpty(startTime) || StringUtils.isEmpty(endTime)),
                        CashWithdrawals::getCreated,
                        startTime, endTime + " 23:59:59"
                );
        Page<CashWithdrawals> pageDate = page(page, cashWithdrawalsLambdaQueryWrapper);
        List<CashWithdrawals> records = pageDate.getRecords();
        if (!CollectionUtils.isEmpty(records)) {
            List<Long> userIds = records.stream().map(CashWithdrawals::getUserId).collect(Collectors.toList());
            if (basicUsers == null) {
                basicUsers = userServiceFeign.getBasicUsers(userIds, null, null);
            }
            Map<Long, UserDto> finalBasicUsers = basicUsers;
            records.forEach(cashWithdrawals -> {
                UserDto userDto = finalBasicUsers.get(cashWithdrawals.getUserId());
                if (userDto != null) {
                    cashWithdrawals.setUsername(userDto.getUsername());
                    cashWithdrawals.setRealName(userDto.getRealName());
                }
            });
        }
        return pageDate;
    }

    /**
     * 查询用户的提现记录
     *
     * @param page
     * @param userId
     * @param status
     * @return
     */
    @Override
    public Page<CashWithdrawals> findCashWithdrawals(Page<CashWithdrawals> page, Long userId, Byte status) {
        return page(page, new LambdaQueryWrapper<CashWithdrawals>()
                .eq(CashWithdrawals::getUserId, userId)
                .eq(status != null, CashWithdrawals::getStatus, status));
    }


    /**
     * GCN的卖出操作
     *
     * @param userId
     * @param cashSellParam
     * @return
     */
    @Override
    public boolean sell(Long userId, CashSellParam cashSellParam) {
        //1 参数校验
        checkCashSellParam(cashSellParam);
        Map<Long, UserDto> basicUsers = userServiceFeign.getBasicUsers(Arrays.asList(userId), null, null);
        if (CollectionUtils.isEmpty(basicUsers)) {
            throw new IllegalArgumentException("用户的id错误");
        }
        UserDto userDto = basicUsers.get(userId);
        // 2 手机验证码
        validatePhoneCode(userDto.getMobile(),cashSellParam.getValidateCode()) ;
        // 3 支付密码
        checkUserPayPassword(userDto.getPaypassword(), cashSellParam.getPayPassword());
        // 4 远程调用查询用户的银行卡
        UserBankDto userBankInfo = userBankServiceFeign.getUserBankInfo(userId);
        if (userBankInfo == null) {
            throw new IllegalArgumentException("该用户暂未绑定银行卡信息");
        }
        String remark = RandomUtil.randomNumbers(6);
        // 5 通过数量得到本次交易的金额
        BigDecimal amount = getCashWithdrawalsAmount(cashSellParam.getNum());
        // 6 计算本次的手续费
        BigDecimal fee = getCashWithdrawalsFee(amount);
        // 7 查询用户的账号ID
        Account account = accountService.findByUserAndCoin(userId, "GCN");
        // 7 订单的创建
        CashWithdrawals cashWithdrawals = new CashWithdrawals();
        cashWithdrawals.setUserId(userId);
        cashWithdrawals.setAccountId(account.getId());
        cashWithdrawals.setCoinId(cashSellParam.getCoinId());
        cashWithdrawals.setStatus((byte) 0);
        cashWithdrawals.setStep((byte) 1);
        cashWithdrawals.setNum(cashSellParam.getNum());
        cashWithdrawals.setMum(amount.subtract(fee)); // 实际金额 = amount-fee
        cashWithdrawals.setFee(fee);
        cashWithdrawals.setBank(userBankInfo.getBank());
        cashWithdrawals.setBankCard(userBankInfo.getBankCard());
        cashWithdrawals.setBankAddr(userBankInfo.getBankAddr());
        cashWithdrawals.setBankProv(userBankInfo.getBankProv());
        cashWithdrawals.setBankCity(userBankInfo.getBankCity());
        cashWithdrawals.setTruename(userBankInfo.getRealName());
        cashWithdrawals.setRemark(remark);
        boolean save = save(cashWithdrawals);
        if (save) { //
            // 扣减总资产--account-->accountDetail
            accountService.lockUserAmount(userId, cashWithdrawals.getCoinId(), cashWithdrawals.getMum(), "withdrawals_out", cashWithdrawals.getId(), cashWithdrawals.getFee());
        }
        return save;
    }

    /**
     * 计算本次的手续费
     *
     * @param amount
     * @return
     */
    private BigDecimal getCashWithdrawalsFee(BigDecimal amount) {
        // 1 通过总金额* 费率 = 手续费
        // 2 若金额较小---->最小的提现的手续费

        // 最小的提现费用
        Config withdrawMinPoundage = configService.getConfigByCode("WITHDRAW_MIN_POUNDAGE");
        BigDecimal withdrawMinPoundageFee = new BigDecimal(withdrawMinPoundage.getValue());

        // 提现的费率
        Config withdrawPoundageRate = configService.getConfigByCode("WITHDRAW_POUNDAGE_RATE");


        // 通过费率计算的手续费
        BigDecimal poundageFee = amount.multiply(new BigDecimal(withdrawPoundageRate.getValue())).setScale(2, RoundingMode.HALF_UP);

        //min 取2 个的最小值
        return poundageFee.min(withdrawMinPoundageFee).equals(poundageFee) ? withdrawMinPoundageFee : poundageFee;
    }

    /**
     * 通过数量计算金额
     *
     * @param num
     * @return
     */
    private BigDecimal getCashWithdrawalsAmount(BigDecimal num) {
        //
        Config rateConfig = configService.getConfigByCode("USDT2CNY");
        return num.multiply(new BigDecimal(rateConfig.getValue())).setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * 支付密码的校验
     *
     * @param payDBPassword
     * @param payPassword
     */
    private void checkUserPayPassword(String payDBPassword, String payPassword) {
        BCryptPasswordEncoder bCryptPasswordEncoder = new BCryptPasswordEncoder();
        boolean matches = bCryptPasswordEncoder.matches(payPassword, payDBPassword);
        if (!matches) {
            throw new IllegalArgumentException("支付密码错误");
        }
    }

    /**
     * 校验用户的手机验证码
     *
     * @param mobile
     * @param validateCode
     */
    private void validatePhoneCode(String mobile, String validateCode) {

        // 验证:SMS:CASH_WITHDRAWS:mobile
        String code = redisTemplate.opsForValue().get("SMS:CASH_WITHDRAWS:" + mobile);
        if (!validateCode.equals(code)) {
            throw new IllegalArgumentException("验证码错误");
        }

    }

    /**
     * 1 手机验证码
     * 2 支付密码
     * 3 提现相关的验证
     *
     * @param cashSellParam
     */
    private void checkCashSellParam(CashSellParam cashSellParam) {
        // 1 提现状态
        Config cashWithdrawalsStatus = configService.getConfigByCode("WITHDRAW_STATUS");
        if (Integer.valueOf(cashWithdrawalsStatus.getValue()) != 1) {
            throw new IllegalArgumentException("提现暂未开启");
        }
        // 2 提现的金额
        @NotNull BigDecimal cashSellParamNum = cashSellParam.getNum();
        // 2.1 最小的提现额度100
        Config cashWithdrawalsConfigMin = configService.getConfigByCode("WITHDRAW_MIN_AMOUNT");
        //101
        if (cashSellParamNum.compareTo(new BigDecimal(cashWithdrawalsConfigMin.getValue())) < 0) {
            throw new IllegalArgumentException("检查提现的金额");
        }
        // 2.1 最小的提现额度200
        // 201
        Config cashWithdrawalsConfigMax = configService.getConfigByCode("WITHDRAW_MAX_AMOUNT");
        if (cashSellParamNum.compareTo(new BigDecimal(cashWithdrawalsConfigMax.getValue())) >= 0) {
            throw new IllegalArgumentException("检查提现的金额");
        }
    }


    /**
     * 审核提现记录
     *
     * @param userId
     * @param cashWithdrawAuditRecord
     * @return
     */
    @Override
    public boolean updateWithdrawalsStatus(Long userId, CashWithdrawAuditRecord cashWithdrawAuditRecord) {
        // 1 使用锁锁住
        boolean isOk = lock.tryLockAndRun(cashWithdrawAuditRecord.getId() + "", 300, TimeUnit.SECONDS, () -> {
            CashWithdrawals cashWithdrawals = getById(cashWithdrawAuditRecord.getId());
            if (cashWithdrawals == null) {
                throw new IllegalArgumentException("现金的审核记录不存在");
            }

            // 2 添加一个审核的记录
            CashWithdrawAuditRecord cashWithdrawAuditRecordNew = new CashWithdrawAuditRecord();
            cashWithdrawAuditRecordNew.setAuditUserId(userId);
            cashWithdrawAuditRecordNew.setRemark(cashWithdrawAuditRecord.getRemark());
            cashWithdrawAuditRecordNew.setCreated(new Date());
            cashWithdrawAuditRecordNew.setStatus(cashWithdrawAuditRecord.getStatus());
            Integer step = cashWithdrawals.getStep() + 1;
            cashWithdrawAuditRecordNew.setStep(step.byteValue());
            cashWithdrawAuditRecordNew.setOrderId(cashWithdrawals.getId());

            // 记录保存成功
            int count = cashWithdrawAuditRecordMapper.insert(cashWithdrawAuditRecordNew);
            if (count > 0) {
                cashWithdrawals.setStatus(cashWithdrawAuditRecord.getStatus());
                cashWithdrawals.setRemark(cashWithdrawAuditRecord.getRemark());
                cashWithdrawals.setLastTime(new Date());
                cashWithdrawals.setAccountId(userId); //
                cashWithdrawals.setStep(step.byteValue());
                boolean updateById = updateById(cashWithdrawals);   // 审核拒绝
                if (updateById) {
                    // 审核通过 withdrawals_out
                    Boolean isPass = accountService.decreaseAccountAmount(
                            userId, cashWithdrawals.getUserId(), cashWithdrawals.getCoinId(),
                            cashWithdrawals.getId(), cashWithdrawals.getNum(), cashWithdrawals.getFee(),
                            cashWithdrawals.getRemark(), "withdrawals_out", (byte) 2
                    );
                }
            }
        });

        return isOk;
    }
}

