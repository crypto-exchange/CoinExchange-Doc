package com.bjsxt.controller;

import com.bjsxt.model.R;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Api(tags = "交易系统的测试")
public class TestController {

    @GetMapping("/test")
    @ApiOperation(value = "交易系统测试")
    public R<String> test(){
        return R.ok("交易系统测试成功") ;
    }
}
