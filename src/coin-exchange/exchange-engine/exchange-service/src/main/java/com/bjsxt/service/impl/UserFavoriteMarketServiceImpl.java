package com.bjsxt.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bjsxt.domain.UserFavoriteMarket;
import com.bjsxt.mapper.UserFavoriteMarketMapper;
import org.springframework.stereotype.Service;
@Service
public class UserFavoriteMarketServiceImpl extends ServiceImpl<UserFavoriteMarketMapper, UserFavoriteMarket> implements UserFavoriteMarketService{

    /**
     * 用户取消收藏
     *
     * @param marketId // 交易市场的id
     * @param userId // 用户的Id
     * @return
     */
    @Override
    public boolean deleteUserFavoriteMarket(Long marketId, Long userId) {
        return remove(new LambdaQueryWrapper<UserFavoriteMarket>()
                                .eq(UserFavoriteMarket::getMarketId, marketId)
                                .eq(UserFavoriteMarket::getUserId, userId)
            );
    }
}
