package com.bjsxt.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bjsxt.domain.TradeArea;
import com.bjsxt.dto.TradeAreaDto;
import com.bjsxt.feign.TradingAreaServiceClient;
import com.bjsxt.model.R;
import com.bjsxt.service.TradeAreaService;
import com.bjsxt.vo.TradeAreaMarketVo;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import springfox.documentation.annotations.ApiIgnore;

import java.util.List;

@RestController
@RequestMapping("/tradeAreas") //tradeAreas
@Api(tags = "交易区域的数据接口")
public class TradeAreaController implements TradingAreaServiceClient {


    @Autowired
    private TradeAreaService tradeAreaService;

    @GetMapping
    @ApiOperation(value = "交易区域的分页查询")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "current", value = "当前页"),
            @ApiImplicitParam(name = "size", value = "每页显示的条数"),
            @ApiImplicitParam(name = "name", value = "交易区域的名称"),
            @ApiImplicitParam(name = "status", value = "交易区域的状态"),
    })
    @PreAuthorize("hasAuthority('trade_area_query')")
    public R<Page<TradeArea>> findByPage(@ApiIgnore Page<TradeArea> page, String name, Byte status) {
        Page<TradeArea> pageData = tradeAreaService.findByPage(page, name, status);
        return R.ok(pageData);
    }


    @PostMapping
    @ApiOperation(value = "新增一个交易区域")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "tradeArea", value = "tradeAreajson")
    })
    @PreAuthorize("hasAuthority('trade_area_create')")
    public R save(@RequestBody TradeArea tradeArea) {
        boolean save = tradeAreaService.save(tradeArea);
        if (save) {
            return R.ok();
        }
        return R.fail("新增失败");
    }


    @PatchMapping
    @ApiOperation(value = "修改一个交易区域")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "tradeArea", value = "tradeAreajson")
    })
    @PreAuthorize("hasAuthority('trade_area_update')")
    public R update(@RequestBody TradeArea tradeArea) {
        boolean update = tradeAreaService.updateById(tradeArea);
        if (update) {
            return R.ok();
        }
        return R.fail("修改失败");
    }


    @PostMapping("/status")
    @ApiOperation(value = "修改一个交易区域的状态")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "tradeArea", value = "tradeAreajson")
    })
    @PreAuthorize("hasAuthority('trade_area_update')")
    public R updateStatus(@RequestBody TradeArea tradeArea) {
        boolean update = tradeAreaService.updateById(tradeArea);
        if (update) {
            return R.ok();
        }
        return R.fail("修改失败");
    }


    @GetMapping("/all")
    @ApiOperation(value = "查询交易区域")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "status", value = "交易区域的状态")
    })
    @PreAuthorize("hasAuthority('trade_area_query')")
    public R<List<TradeArea>> findAll(Byte status) {
        List<TradeArea> tradeAreas = tradeAreaService.findAll(status);
        return R.ok(tradeAreas);
    }


    @GetMapping("/markets")
    @ApiOperation(value = "查询交易区域,以及区域下的市场")
    public R<List<TradeAreaMarketVo>> getTradeAreaMarkets(){
        List<TradeAreaMarketVo> tradeAreaMarketVos =  tradeAreaService.findTradeAreaMarket();
        return R.ok(tradeAreaMarketVos) ;
    }

    @GetMapping("/market/favorite")
    @ApiOperation(value = "用户收藏的交易市场")
    public R<List<TradeAreaMarketVo>> getUserFavoriteMarkets(){
       Long userId =  Long.valueOf(SecurityContextHolder.getContext().getAuthentication().getPrincipal().toString());
        List<TradeAreaMarketVo> tradeAreaMarketVos =  tradeAreaService.getUserFavoriteMarkets(userId) ;
        return R.ok(tradeAreaMarketVos) ;
    }

    /**
     * 查询所有的交易区域
     *
     * @return
     */
    @Override
    public List<TradeAreaDto> tradeAreas() {
        List<TradeAreaDto> tradeAreaDtoList =  tradeAreaService.findAllTradeAreaAndMarket();
        return tradeAreaDtoList ;
    }
}
