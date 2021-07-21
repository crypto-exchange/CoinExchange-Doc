package com.bjsxt.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bjsxt.domain.SysRole;
import com.bjsxt.mapper.SysPrivilegeMapper;
import com.bjsxt.mapper.SysRoleMapper;
import com.bjsxt.service.SysRoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.io.Serializable;

@Service
public class SysRoleServiceImpl extends ServiceImpl<SysRoleMapper, SysRole> implements SysRoleService {

    @Autowired
    private SysRoleMapper sysRoleMapper;

    @Autowired
    private SysPrivilegeMapper sysPrivilegeMapper ;


    /**
     * 根据 ID 查询
     *
     * @param id 主键ID
     */
    @Override
    public SysRole getById(Serializable id) {
        SysRole sysRole = super.getById(id);
        sysRole.setPrivileges(sysPrivilegeMapper.selectByRoleId(sysRole.getId()));
        return sysRole;
    }

    /**
     * 判断一个用户是否为超级的管理员
     *
     * @param userId
     * @return
     */
    @Override
    public boolean isSuperAdmin(Long userId) {
        // 当用户的角色code 为：ROLE_ADMIN 时，该用户为超级的管理员
        // 用户的id->用户的角色->该角色的Code是否为ROLE_ADMIN
        String roleCode = sysRoleMapper.getUserRoleCode(userId);
        if (!StringUtils.isEmpty(roleCode) && roleCode.equals("ROLE_ADMIN")) {
            return true;
        }
        return false;
    }

    /**
     * 使用角色的名称模糊分页角色查询
     *
     * @param page 分页数据
     * @param name 角色的名称
     * @return
     */
    @Override
    public Page<SysRole> findByPage(Page<SysRole> page, String name) {
        return page(page, new LambdaQueryWrapper<SysRole>().like(
                !StringUtils.isEmpty(name),
                SysRole::getName,
                name
        ));
    }
}
