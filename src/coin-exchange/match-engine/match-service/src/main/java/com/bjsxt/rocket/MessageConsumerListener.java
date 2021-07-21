package com.bjsxt.rocket;


import com.bjsxt.disruptor.DisruptorTemplate;
import com.bjsxt.domain.EntrustOrder;
import com.bjsxt.model.Order;
import com.bjsxt.util.BeanUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.stream.annotation.StreamListener;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class MessageConsumerListener {

    @Autowired
    private DisruptorTemplate disruptorTemplate;

    @StreamListener("order_in")
    public void handleMessage(EntrustOrder entrustOrder) {
        Order order = null;
        if (entrustOrder.getStatus() == 2) { // 该单需要取消
            order = new Order();
            order.setOrderId(entrustOrder.getId().toString());
            order.setCancelOrder(true);
        } else {
            order = BeanUtils.entrustOrder2Order(entrustOrder);
        }
        log.info("接收到了委托单:{}", order);
        disruptorTemplate.onData(order);
    }
}
