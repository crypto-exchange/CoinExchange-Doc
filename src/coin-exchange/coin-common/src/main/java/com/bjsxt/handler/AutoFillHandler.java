package com.bjsxt.handler;

import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import org.apache.ibatis.reflection.MetaObject;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class AutoFillHandler implements MetaObjectHandler {

    /**
     * 插入元对象字段填充（用于插入时对公共字段的填充）
     * 新增数据时要添加的为：
     * 1 创建人
     * 2 创建时间
     * 3 lastupdatetime
     *
     * @param metaObject 元对象
     */
    @Override
    public void insertFill(MetaObject metaObject) {

        Long userId = getCurrentUserId();
        this.strictInsertFill(metaObject, "createBy", Long.class, userId); // 创建人
        this.strictInsertFill(metaObject, "created", Date.class, new Date()); // 创建时间
        this.strictInsertFill(metaObject, "lastUpdateTime", Date.class, new Date()); // 修改时间
    }


    /**
     * 更新元对象字段填充（用于更新时对公共字段的填充）
     * //1 修改人
     * // 2 修改时间
     *
     * @param metaObject 元对象
     */
    @Override
    public void updateFill(MetaObject metaObject) {
        Long userId = getCurrentUserId();

        this.strictUpdateFill(metaObject, "modifyBy", Long.class, userId); // 修改人
        this.strictUpdateFill(metaObject, "lastUpdateTime", Date.class, new Date()); // 修改时间
    }

    /**
     * 获取当前操作的用户对象
     * @return
     */
    private Long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication(); // 从安全的上下文里面获取用户的ud
        if(authentication!=null){
            String s = authentication.getPrincipal().toString(); // userId ->Long  anonymousUser
            if("anonymousUser".equals(s)){ //是因为用户没有登录访问时,就是这个用户
                return null ;
            }
            return Long.valueOf(s) ;
        }
        return null ;
    }
}
