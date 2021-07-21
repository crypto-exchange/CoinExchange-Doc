package com.bjsxt.service.impl;

import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import java.util.List;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bjsxt.mapper.TurnoverRecordMapper;
import com.bjsxt.domain.TurnoverRecord;
import com.bjsxt.service.TurnoverRecordService;
@Service
public class TurnoverRecordServiceImpl extends ServiceImpl<TurnoverRecordMapper, TurnoverRecord> implements TurnoverRecordService{

}
