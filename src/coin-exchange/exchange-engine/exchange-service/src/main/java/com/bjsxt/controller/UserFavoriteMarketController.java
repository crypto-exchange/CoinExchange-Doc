package com.bjsxt.controller;

import cn.hutool.core.lang.Snowflake;
import com.bjsxt.domain.Market;
import com.bjsxt.domain.UserFavoriteMarket;
import com.bjsxt.model.R;
import com.bjsxt.service.MarketService;
import com.bjsxt.service.impl.UserFavoriteMarketService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import javax.validation.constraints.NotNull;

@RestController
@RequestMapping("/userFavorites")
@Api(tags = "用户市场收藏控制器")
public class UserFavoriteMarketController {

    @Autowired
    private UserFavoriteMarketService userFavoriteMarketService;

    @Autowired
    private MarketService marketService;

    @Autowired
    private Snowflake snowflake ;

    @PostMapping("/addFavorite")
    @ApiOperation(value = "用户收藏某个市场")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "market", value = "market的交易对和类型")
    })
    public R addFavorite(@RequestBody Market market) {
        Long userId = Long.valueOf(SecurityContextHolder.getContext().getAuthentication().getPrincipal().toString()) ;
        UserFavoriteMarket userFavoriteMarket = new UserFavoriteMarket();
        @NotNull String symbol = market.getSymbol(); // 市场的symbol
        Market marketDb = marketService.getMarkerBySymbol(symbol);

        userFavoriteMarket.setId(snowflake.nextId()); // 使用雪花算法生成Id
        userFavoriteMarket.setUserId(userId);
        userFavoriteMarket.setMarketId(marketDb.getId());
        userFavoriteMarket.setType(market.getType().intValue()); // 该字段暂未使用
        boolean save = userFavoriteMarketService.save(userFavoriteMarket);
        if (save) {
            return R.ok("收藏成功");
        }
        return R.fail("收藏失败");
    }


    @DeleteMapping("/{symbol}")
    @ApiOperation(value = "用户取消收藏某个市场")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "symbol" ,value = "交易对")
    })
    public R deleteUserFavoriteMarket(@PathVariable("symbol") String symbol){
        Market markerBySymbol = marketService.getMarkerBySymbol(symbol);
        Long userId = Long.valueOf(SecurityContextHolder.getContext().getAuthentication().getPrincipal().toString()) ;
       boolean isOk =  userFavoriteMarketService.deleteUserFavoriteMarket(markerBySymbol.getId(),userId) ;
       if(isOk){
           return R.ok() ;
       }
       return R.fail("取消失败") ;
    }
}
