package com.bjsxt.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bjsxt.domain.Notice;
import com.bjsxt.mapper.NoticeMapper;
import com.bjsxt.service.NoticeService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class NoticeServiceImpl extends ServiceImpl<NoticeMapper, Notice> implements NoticeService{

    /**
     * 条件查询公告
     *
     * @param page      分页参数
     * @param title     公告的标签
     * @param startTime 公告创建的开始时间
     * @param endTime   公告创建的结束时间
     * @param status    公告当前的状态
     * @return
     */
    @Override
    public Page<Notice> findByPage(Page<Notice> page, String title, String startTime, String endTime, Integer status) {
        return page(page,new LambdaQueryWrapper<Notice>()
                    .like(!StringUtils.isEmpty(title),Notice::getTitle,title)
                    .between(!StringUtils.isEmpty(startTime)&&!StringUtils.isEmpty(endTime) ,Notice::getCreated,startTime,endTime+" 23:59:59")
                    .eq(status!=null,Notice::getStatus,status)
        );
    }

    /**
     * 查询公告
     *
     * @param page
     * @return
     */
    @Override
    public Page<Notice> findNoticeForSimple(Page<Notice> page) {
        return page(page,new LambdaQueryWrapper<Notice>()
                                    .eq(Notice::getStatus,1)
                                    .orderByAsc(Notice::getSort)
        );
    }
}
