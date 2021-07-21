package com.bjsxt.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bjsxt.domain.User;
import com.bjsxt.domain.UserWallet;
import com.bjsxt.mapper.UserWalletMapper;
import com.bjsxt.service.UserService;
import com.bjsxt.service.UserWalletService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class UserWalletServiceImpl extends ServiceImpl<UserWalletMapper, UserWallet> implements UserWalletService{


    @Autowired
    private UserService userService ;
    /**
     * 分页查询用户的提币地址
     *
     * @param page   分页参数
     * @param userId 用户的ID
     * @return
     */
    @Override
    public Page<UserWallet> findByPage(Page<UserWallet> page, Long userId) {
        return page(page, new LambdaQueryWrapper<UserWallet>().eq(UserWallet::getUserId ,userId));
    }

    /**
     * 查询用户的提币的地址
     *
     * @param userId 用户的Id
     * @param coinId 币种的Id
     * @return
     */
    @Override
    public List<UserWallet> findUserWallets(Long userId, Long coinId) {
        return list(new LambdaQueryWrapper<UserWallet>()
                                    .eq(UserWallet::getUserId,userId)
                                    .eq(UserWallet::getCoinId,coinId)
        )   ;
    }

    @Override
    public boolean save(UserWallet entity) {
        Long userId = entity.getUserId();
        User user = userService.getById(userId);
        if(user==null){
            throw new IllegalArgumentException("该用户不存在") ;
        }
        String paypassword = user.getPaypassword();
        if(StringUtils.isEmpty(paypassword) ||  !(new BCryptPasswordEncoder().matches(entity.getPayPassword(),paypassword))){
            throw new IllegalArgumentException("交易密码错误") ;
        }
        return super.save(entity);
    }


    /**
     * 删除用户的提现地址
     *
     * @param addressId   提现地址的Id
     * @param payPassword 交易密码
     * @return
     */
    @Override
    public boolean deleteUserWallet(Long addressId, String payPassword) {
        UserWallet userWallet = getById(addressId);
        if(userWallet==null){
            throw new IllegalArgumentException("提现地址错误") ;
        }
        Long userId = userWallet.getUserId();
        User user = userService.getById(userId);
        if(user==null){
            throw new IllegalArgumentException("用户不存在") ;
        }
        String paypassword = user.getPaypassword();
        if(StringUtils.isEmpty(paypassword) ||  !(new BCryptPasswordEncoder().matches(payPassword,paypassword))){
            throw new IllegalArgumentException("交易密码错误") ;
        }
        return super.removeById(addressId);
    }
}
