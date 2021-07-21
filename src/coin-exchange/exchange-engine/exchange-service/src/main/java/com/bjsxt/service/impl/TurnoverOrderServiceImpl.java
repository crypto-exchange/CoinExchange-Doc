package com.bjsxt.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bjsxt.domain.TurnoverOrder;
import com.bjsxt.dto.TurnoverData24HDTO;
import com.bjsxt.mapper.TurnoverOrderMapper;
import com.bjsxt.service.TurnoverOrderService;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
public class TurnoverOrderServiceImpl extends ServiceImpl<TurnoverOrderMapper, TurnoverOrder> implements TurnoverOrderService {

    /**
     * 查询分页对象
     *
     * @param page   分页数据
     * @param userId 用户的ID
     * @param symbol 交易对
     * @param type   交易类型
     * @return
     */
    @Override
    public Page<TurnoverOrder> findByPage(Page<TurnoverOrder> page, Long userId, String symbol, Integer type) {
//        return page(page,new LambdaQueryWrapper<TurnoverOrder>().eq(TurnoverOrder::getus));
        return null;
    }


    /**
     * 获取买入的订单的成功的记录
     *
     * @param orderId
     * @return
     */
    @Override
    public List<TurnoverOrder> getBuyTurnoverOrder(Long orderId, Long userId) {
        return list(new LambdaQueryWrapper<TurnoverOrder>().eq(TurnoverOrder::getOrderId, orderId)
                .eq(TurnoverOrder::getBuyUserId, userId)
        );
    }


    /**
     * 获取卖出订单的成交记录
     *
     * @param orderId
     * @return
     */
    @Override
    public List<TurnoverOrder> getSellTurnoverOrder(Long orderId,Long userId) {
        return list(new LambdaQueryWrapper<TurnoverOrder>().eq(TurnoverOrder::getOrderId, orderId)
                .eq(TurnoverOrder::getSellUserId, userId)
        );

    }

    /**
     * 根据交易市场查询我们的成交记录
     *
     * @param symbol
     * @return
     */
    @Override
    public List<TurnoverOrder> findBySymbol(String symbol) {
        List<TurnoverOrder> turnoverOrders = list(
                new LambdaQueryWrapper<TurnoverOrder>()
                        .eq(TurnoverOrder::getSymbol, symbol)
                        .orderByDesc(TurnoverOrder::getCreated)
                        .eq(TurnoverOrder::getStatus,1)
                        .last("limit 60")
        );
        return turnoverOrders;
    }

    /**
     * 查询该交易对的24 小时成交记录
     *
     * @param symbol
     * @return
     */
    @Override
    public TurnoverData24HDTO query24HDealData(String symbol) {
        TurnoverData24HDTO turnoverData24HDTO = new TurnoverData24HDTO();
        turnoverData24HDTO.setAmount(BigDecimal.valueOf(1000)) ;
        turnoverData24HDTO.setVolume(BigDecimal.valueOf(100000)) ;
        return turnoverData24HDTO;
    }
}
