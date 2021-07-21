package com.bjsxt.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.bjsxt.domain.CashWithdrawAuditRecord;
import com.bjsxt.domain.CashWithdrawals;
import com.bjsxt.model.CashSellParam;

public interface CashWithdrawalsService extends IService<CashWithdrawals> {


    /**
     * 提现记录的查询
     * @param page
     * 分页数据
     * @param userId
     * 用户的id
     * @param userName
     * 用户的名称
     * @param mobile
     * 用户的手机号
     * @param status
     * 提现的状态
     * @param numMin
     * 提现的最小金额
     * @param numMax
     * 提现的最大金额
     * @param startTime
     * 提现的开始时间
     * @param endTime
     * 提现的截至时间
     * @return
     */
    Page<CashWithdrawals> findByPage(Page<CashWithdrawals> page, Long userId, String userName, String mobile, Byte status, String numMin, String numMax, String startTime, String endTime);

    /**
     * 查询用户的提现记录
     * @param page
     * @param userId
     * @param status
     * @return
     */
    Page<CashWithdrawals> findCashWithdrawals(Page<CashWithdrawals> page, Long userId, Byte status);

    /**
     * GCN的卖出操作
     * @param userId
     * @param cashSellParam
     * @return
     */
    boolean sell(Long userId, CashSellParam cashSellParam);


    /**
     * 审核提现记录
     * @param userId
     * @param cashWithdrawAuditRecord
     * @return
     */
    boolean updateWithdrawalsStatus(Long userId, CashWithdrawAuditRecord cashWithdrawAuditRecord);
}

