package com.bjsxt.rocket;

import com.bjsxt.dto.CreateKLineDto;
import com.bjsxt.model.ExchangeTrade;
import com.bjsxt.service.TradeKlineService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.stream.annotation.StreamListener;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.util.List;

@Component
@Slf4j
public class ExchangeTradesListener {


    @StreamListener("exchange_trades_in")
    public void handlerExchangeTrades(List<ExchangeTrade> exchangeTrades) {
        log.info("接收到撮合引擎的数据===>{}", exchangeTrades);
        if (!CollectionUtils.isEmpty(exchangeTrades)) {
            for (ExchangeTrade exchangeTrade : exchangeTrades) {
                if(exchangeTrade==null){
                    return;
                }
//                mongoTemplate.insert(exchangeTrade) ;
                CreateKLineDto createKLineDto = exchangeTrade2CreateKLineDto(exchangeTrade);
                TradeKlineService.queue.offer(createKLineDto);
            }
        }
    }

    private CreateKLineDto exchangeTrade2CreateKLineDto(ExchangeTrade exchangeTrade) {
        CreateKLineDto createKLineDto = new CreateKLineDto();
        createKLineDto.setPrice(exchangeTrade.getPrice());
        createKLineDto.setSymbol(exchangeTrade.getSymbol());
        createKLineDto.setVolume(exchangeTrade.getAmount());
        return createKLineDto;
    }

}
