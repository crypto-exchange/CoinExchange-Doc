package com.bjsxt.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.bjsxt.domain.SysMenu;

import java.util.List;

public interface SysMenuMapper extends BaseMapper<SysMenu> {

    /**
     * 通过用户的id 查询用户的菜单数据
     * @param userId
     * @return
     */
    List<SysMenu> selectMenusByUserId(Long userId);

    /**
     * 使用角色的Id 查询所有菜单列表
     * @param roleId
     * @return
     */
    List<SysMenu> selectMenusByRoleId(Long roleId);
}