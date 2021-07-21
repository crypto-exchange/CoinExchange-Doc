package com.bjsxt.controller;

import com.bjsxt.model.R;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Api(tags = "财务系统的测试")
public class TestController {


    @GetMapping("/test")
    @ApiOperation(value = "财务系统的测试接口")
    public R test(){
        return R.ok("测试成功") ;
    }
}
