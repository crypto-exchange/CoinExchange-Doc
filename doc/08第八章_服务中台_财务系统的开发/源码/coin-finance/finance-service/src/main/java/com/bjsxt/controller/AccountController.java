package com.bjsxt.controller;

import com.bjsxt.domain.Account;
import com.bjsxt.model.R;
import com.bjsxt.service.AccountService;
import com.bjsxt.vo.SymbolAssetVo;
import com.bjsxt.vo.UserTotalAccountVo;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/account")
@Api(tags = "资产服务的控制器")
public class AccountController {


    @Autowired
    private AccountService accountService ;

    @GetMapping("/{coinName}")
    @ApiOperation(value = "获取当前用户的货币的资产情况")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "coinName" ,value = "货币的名称")
    })
    public R<Account> getUserAccount(@PathVariable("coinName")String coinName){
        Long userId = Long.valueOf(SecurityContextHolder.getContext().getAuthentication().getPrincipal().toString()) ;
        Account account = accountService.findByUserAndCoin(userId,coinName) ;
        return R.ok(account) ;
    }

    @GetMapping("/total")
    @ApiOperation(value = "计算用户的总资产")
    public R<UserTotalAccountVo> total(){
        Long userId = Long.valueOf(SecurityContextHolder.getContext().getAuthentication().getPrincipal().toString()) ;
        UserTotalAccountVo userTotalAccountVo = accountService.getUserTotalAccount(userId) ;
        return R.ok(userTotalAccountVo) ;
    }


    @GetMapping("/asset/{symbol}")
    @ApiOperation(value = "交易货币的资产")
    public R<SymbolAssetVo> getSymbolAssert(@PathVariable("symbol") String symbol){
        Long userId = Long.valueOf(SecurityContextHolder.getContext().getAuthentication().getPrincipal().toString()) ;
        SymbolAssetVo symbolAssetVo =  accountService.getSymbolAssert(symbol,userId) ;
        return R.ok(symbolAssetVo) ;
    }
}
