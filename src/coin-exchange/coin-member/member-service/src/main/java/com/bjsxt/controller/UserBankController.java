package com.bjsxt.controller;

import com.baomidou.mybatisplus.core.metadata.OrderItem;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bjsxt.domain.UserBank;
import com.bjsxt.dto.UserBankDto;
import com.bjsxt.feign.UserBankServiceFeign;
import com.bjsxt.mappers.UserBankDtoMapper;
import com.bjsxt.model.R;
import com.bjsxt.service.UserBankService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/userBanks")
@Api(tags = "会员的银行卡管理")
public class UserBankController implements UserBankServiceFeign {


    @Autowired
    private UserBankService userBankService ;


    @GetMapping
    @ApiOperation(value = "分页查询用户的银行卡")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "usrId" ,value = "会员的Id") ,
            @ApiImplicitParam(name = "current" ,value = "当前页")  ,
            @ApiImplicitParam(name = "size" ,value = "每页显示的条数")
    })
    @PreAuthorize("hasAuthority('user_bank_query')")
    public R<Page<UserBank>> findByPage(Page<UserBank> page , Long usrId){
        page.addOrder(OrderItem.desc("last_update_time")) ;
        Page<UserBank> userBankPage = userBankService.findByPage(page ,usrId) ;
        return R.ok(userBankPage) ;
    }


    @PostMapping("/status")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "id" ,value = "银行卡的Id") ,
            @ApiImplicitParam(name = "status" ,value = "银行卡的状态") ,
    })
    @ApiOperation(value = "修改银行卡的状态")
    public R updateStatus(Long id ,Byte status){
        UserBank userBank = new UserBank();
        userBank.setId(id);
        userBank.setStatus(status);
        boolean updateById = userBankService.updateById(userBank);
        if(updateById){
            return R.ok() ;
        }
        return R.fail("银行卡状态修改失败") ;
    }


    @PatchMapping
    @ApiImplicitParams({
            @ApiImplicitParam(name = "userBank" ,value = "银行卡的json数据") ,
    })
    @ApiOperation(value = "修改银行卡")
    public R updateStatus(@RequestBody  @Validated  UserBank userBank){
        boolean updateById = userBankService.updateById(userBank);
        if(updateById){
            return R.ok() ;
        }
        return R.fail("银行卡状态修改失败") ;
    }


    @GetMapping("/current")
    @ApiOperation(value = "查询当前用户的银行卡")
    public R<UserBank> getCurrentUserBank(){
        Long userId = Long.valueOf(SecurityContextHolder.getContext().getAuthentication().getPrincipal().toString());
        UserBank userBank =  userBankService.getCurrentUserBank(userId) ;
        return R.ok(userBank) ;
    }


    @PostMapping("/bind")
    @ApiOperation(value = "绑定银行卡")
    public  R bindBank(@RequestBody @Validated UserBank userBank){
        Long userId = Long.valueOf(SecurityContextHolder.getContext().getAuthentication().getPrincipal().toString());
        boolean isOk = userBankService.bindBank(userId,userBank) ;
        if(isOk){
            return R.ok() ;
        }
        return R.fail("绑定失败") ;
    }

    @Override
    public UserBankDto getUserBankInfo(Long userId) {
        UserBank currentUserBank = userBankService.getCurrentUserBank(userId);
        UserBankDto userBankDto = UserBankDtoMapper.INSTANCE.toConvertDto(currentUserBank);
        return userBankDto ;
    }
}
