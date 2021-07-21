package com.bjsxt.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bjsxt.domain.UserLoginLog;
import com.bjsxt.mapper.UserLoginLogMapper;
import com.bjsxt.service.UserLoginLogService;
import org.springframework.stereotype.Service;
@Service
public class UserLoginLogServiceImpl extends ServiceImpl<UserLoginLogMapper, UserLoginLog> implements UserLoginLogService{

}
