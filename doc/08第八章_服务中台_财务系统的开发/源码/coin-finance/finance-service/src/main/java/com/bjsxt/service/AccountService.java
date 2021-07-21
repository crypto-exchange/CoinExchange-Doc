package com.bjsxt.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.bjsxt.domain.Account;
import com.bjsxt.vo.SymbolAssetVo;
import com.bjsxt.vo.UserTotalAccountVo;

import java.math.BigDecimal;

public interface AccountService extends IService<Account> {

    /**
     * 查询某个用户的货币资产
     * @param userId
     *  用户的id
     * @param coinName
     * 货币的名称
     * @return
     */
    Account findByUserAndCoin(Long userId, String coinName);

    /**
     * 暂时锁定用户的资产
     * @param userId
     *  用户的id
     * @param coinId
     * 币种的id
     * @param mum
     * 锁定的金额
     * @param type
     *      资金流水的类型
     * @param orderId
     *      订单的Id
     * @param fee
     *  本次操作的手续费
     */
    void lockUserAmount(Long userId, Long coinId, BigDecimal mum, String type, Long orderId, BigDecimal fee);

    /**
     * 计算用户的总的资产
     * @param userId
     * @return
     */
    UserTotalAccountVo getUserTotalAccount(Long userId);

    /**
     * 统计用户交易对的资产
     * @param symbol
     *  交易对的Symbol
     * @param userId
     *      用户的Id
     * @return
     */
    SymbolAssetVo getSymbolAssert(String symbol, Long userId);
}

