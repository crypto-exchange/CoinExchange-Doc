package com.bjsxt.service.impl;

import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import java.util.List;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bjsxt.mapper.ForexOpenPositionOrderMapper;
import com.bjsxt.domain.ForexOpenPositionOrder;
import com.bjsxt.service.ForexOpenPositionOrderService;

@Service
public class ForexOpenPositionOrderServiceImpl extends ServiceImpl<ForexOpenPositionOrderMapper, ForexOpenPositionOrder> implements ForexOpenPositionOrderService {

}

