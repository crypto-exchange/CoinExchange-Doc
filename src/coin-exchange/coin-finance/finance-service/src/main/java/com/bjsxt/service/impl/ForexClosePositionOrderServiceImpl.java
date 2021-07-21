package com.bjsxt.service.impl;

import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import java.util.List;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bjsxt.mapper.ForexClosePositionOrderMapper;
import com.bjsxt.domain.ForexClosePositionOrder;
import com.bjsxt.service.ForexClosePositionOrderService;

@Service
public class ForexClosePositionOrderServiceImpl extends ServiceImpl<ForexClosePositionOrderMapper, ForexClosePositionOrder> implements ForexClosePositionOrderService {

}

