package com.bjsxt.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.bjsxt.domain.UserAuthInfo;

import java.util.List;

public interface UserAuthInfoService extends IService<UserAuthInfo>{

    /**
     * 通过认证的Code 来查询用户的认证详情
     * @param authCode
     * 认证的唯一Code
     * @return
     */
    List<UserAuthInfo> getUserAuthInfoByCode(Long authCode);

    /**
     * 用户未被认证,我们需要通过用户的ID 查询用户的额认证列表
     * @param id
     * @return
     */
    List<UserAuthInfo> getUserAuthInfoByUserId(Long id);
}
