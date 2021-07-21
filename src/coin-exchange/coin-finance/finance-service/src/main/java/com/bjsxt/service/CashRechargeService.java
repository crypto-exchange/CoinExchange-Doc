package com.bjsxt.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.bjsxt.domain.CashRecharge;
import com.bjsxt.domain.CashRechargeAuditRecord;
import com.bjsxt.model.CashParam;
import com.bjsxt.vo.CashTradeVo;

public interface CashRechargeService extends IService<CashRecharge> {

    /**
     * 分页条件查询充值记录
     * @param page
     * 分页参数
     * @param coinId
     * 币种的Id
     * @param userId
     * 用户的Id
     * @param userName
     * 用户的名称
     * @param mobile
     * 用户的手机号
     * @param status
     * 充值的状态
     * @param numMin
     * 充值的最小金额
     * @param numMax
     * 充值的最大金额
     * @param startTime
     * 充值的开始时间
     * @param endTime
     * 充值的截至时间
     * @return
     */
    Page<CashRecharge> findByPage(Page<CashRecharge> page, Long coinId, Long userId, String userName, String mobile, Byte status, String numMin, String numMax, String startTime, String endTime);

    /**
     * 查询当前用户的充值的数据
     * @param page
     * 分页对象
     * @param userId
     * 用户的Id
     * @param status
     * 订单的状态
     * @return
     */

    Page<CashRecharge> findUserCashRecharge(Page<CashRecharge> page, Long userId, Byte status);

    /**
     * 进行一个GCN/充值/购买
     * @param userId
     * 用户的id
     * @param cashParam
     * 现金参数
     * @return
     */
    CashTradeVo buy(Long userId, CashParam cashParam);


    /**
     * 现金的充值审核
     * @param userId
     *  审核人
     * @param cashRechargeAuditRecord
     *  审核的数据
     * @return
     *  是否审核成功
     */
    boolean cashRechargeAudit(Long userId, CashRechargeAuditRecord cashRechargeAuditRecord);
}

