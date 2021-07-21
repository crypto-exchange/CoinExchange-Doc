package com.bjsxt.util;

import com.bjsxt.domain.EntrustOrder;
import com.bjsxt.enums.OrderDirection;
import com.bjsxt.model.Order;

public class BeanUtils {


    /**
     * 将EntrustOrder 转化为我们的Order
     * @param entrustOrder
     * @return
     */
    public static  Order entrustOrder2Order(EntrustOrder entrustOrder) {
        Order order = new Order();
        order.setOrderId(entrustOrder.getId().toString());

        order.setPrice(entrustOrder.getPrice());
        order.setAmount(entrustOrder.getVolume().subtract(entrustOrder.getDeal())); // 交易的数量= 总数量- 已经成交的数量

        order.setSymbol(entrustOrder.getSymbol());
        order.setOrderDirection(OrderDirection.getOrderDirection(entrustOrder.getType().intValue()));
        order.setTime(entrustOrder.getCreated().getTime());

        return order ;

    }
}
