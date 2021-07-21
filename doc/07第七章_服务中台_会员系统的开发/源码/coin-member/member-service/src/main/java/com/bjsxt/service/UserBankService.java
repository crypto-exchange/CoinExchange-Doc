package com.bjsxt.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bjsxt.domain.UserBank;
import com.baomidou.mybatisplus.extension.service.IService;
public interface UserBankService extends IService<UserBank>{


    /**
     * 查询用户的银行卡信息
     * @param page
     * 分页参数
     * @param usrId
     * 用户的Id
     * @return
     */
    Page<UserBank> findByPage(Page<UserBank> page, Long usrId);

    /**
     * 通过用户的ID 查询用户的银行卡
     * @param userId
     * @return
     */
    UserBank getCurrentUserBank(Long userId);

    /**
     * 给用户绑定银行卡
     * @param userId
     *  用户的ID
     * @param userBank
     * 用户的银行卡
     * @return
     */
    boolean bindBank(Long userId, UserBank userBank);
}
