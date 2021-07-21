package com.bjsxt.feign;

import com.bjsxt.config.feign.OAuth2FeignConfig;
import com.bjsxt.dto.TradeAreaDto;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@FeignClient(name = "exchange-service",contextId = "tradingAreaServiceClient" ,configuration = OAuth2FeignConfig.class,path = "/tradeAreas" )
public interface TradingAreaServiceClient {


    /**
     * 查询所有的交易区域
     * @return
     */
    @GetMapping("/query/All")
    List<TradeAreaDto> tradeAreas();
}
