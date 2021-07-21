package com.bjsxt.match;

import com.bjsxt.model.Order;
import com.bjsxt.model.OrderBooks;

/**
 * 撮合/交易的接口定义
 */
public interface MatchService {

    /**
     * 进行订单的撮合交易
     * @param order
     */
    void match(OrderBooks orderBooks, Order order) ;
}
