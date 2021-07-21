package com.bjsxt.config.rocket;

import com.bjsxt.enums.MessageChannel;
import org.springframework.cloud.stream.annotation.Input;

/**
 * 数据的接收
 */
public interface Sink {

    /**
     * 交易数据的输入
     * @return
     */
    @Input("exchange_trade_in")
    MessageChannel exchangeTradeIn() ;



    /**
     * 取消订单的输入
     * @return
     */
    @Input("cancel_order_in")
    MessageChannel cancelOrderIn() ;
}
