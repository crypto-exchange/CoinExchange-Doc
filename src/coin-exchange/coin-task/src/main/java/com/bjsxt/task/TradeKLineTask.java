package com.bjsxt.task;

import com.bjsxt.event.TradeKLineEvent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;

//@Component
//@Slf4j
public class TradeKLineTask {

    @Autowired
    private TradeKLineEvent tradeKLineEvent;

    /**
     * 币币交易生成一次K线
     */
    @Scheduled(fixedRate = 25000)
    public void generateKLine() {
        tradeKLineEvent.handle();
    }
}