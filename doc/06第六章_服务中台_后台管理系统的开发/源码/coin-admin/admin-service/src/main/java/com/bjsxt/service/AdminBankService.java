package com.bjsxt.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.bjsxt.domain.AdminBank;
import com.bjsxt.dto.AdminBankDto;

import java.util.List;

public interface AdminBankService extends IService<AdminBank>{


    /**
     * 条件分页查询公司银行卡
     * @param page
     * 分页参数
     * @param bankCard
     * 银行卡卡号
     * @return
     */
    Page<AdminBank> findByPage(Page<AdminBank> page, String bankCard);


    /**
     * 查询所有的银行开启信息
     * @return
     */
    List<AdminBankDto> getAllAdminBanks();
}
