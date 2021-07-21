package com.bjsxt.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.bjsxt.domain.WorkIssue;
import com.bjsxt.dto.UserDto;
import com.bjsxt.feign.UserServiceFeign;
import com.bjsxt.mapper.WorkIssueMapper;
import com.bjsxt.service.WorkIssueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class WorkIssueServiceImpl extends ServiceImpl<WorkIssueMapper, WorkIssue> implements WorkIssueService {

    @Autowired
    private UserServiceFeign userServiceFeign;

    /**
     * 条件分页查询工单列表
     *
     * @param page      分页参数
     * @param status    工单的状态
     * @param startTime 查询的工单创建起始时间
     * @param endTime   查询的工单创建截至时间
     * @return
     */
    @Override
    public Page<WorkIssue> findByPage(Page<WorkIssue> page, Integer status, String startTime, String endTime) {
        Page<WorkIssue> pageData = page(page, new LambdaQueryWrapper<WorkIssue>()
                .eq(status != null, WorkIssue::getStatus, status)
                .between(
                        !StringUtils.isEmpty(startTime) && !StringUtils.isEmpty(endTime),
                        WorkIssue::getCreated,
                        startTime, endTime + " 23:59:59")
        );
        List<WorkIssue> records = pageData.getRecords();
        if (CollectionUtils.isEmpty(records)) {
            return pageData;
        }
        // 远程调用member-service
        // 错误的示范
//        for (WorkIssue record : records) {
//            Long userId = record.getUserId();
//            // 使用userId->远程调用member-service
//        }
        //1 收集Id
        List<Long> userIds = records.stream().map(WorkIssue::getUserId).collect(Collectors.toList());
        // 2 远程调用
//        List<UserDto> basicUsers = userServiceFeign.getBasicUsers(userIds);
        // 2.1 小技巧: list->map<id,userDto>
//        if(CollectionUtils.isEmpty(basicUsers)){
//            return pageData ;
//        }
//
//        Map<Long, UserDto> idMapUserDtos = basicUsers.stream().
//                                collect(
//                                            Collectors.toMap(
//                                                    userDto -> userDto.getId(),  // key
//                                                    userDto -> userDto) //value
//                                );
        Map<Long, UserDto> idMapUserDtos = userServiceFeign.getBasicUsers(userIds, null, null);
        records.forEach(workIssue -> { // 循环每一个workIssue ,给它里面设置用户的信息 map.get(userId)
            UserDto userDto = idMapUserDtos.get(workIssue.getUserId());
            workIssue.setUsername(userDto == null ? "测试用户" : userDto.getUsername());
            workIssue.setRealName(userDto == null ? "测试用户" : userDto.getRealName());
        });
        return pageData;
    }


    /**
     * 前台系统查询客户工单
     *
     * @param page
     * @return
     */
    @Override
    public Page<WorkIssue> getIssueList(Page<WorkIssue> page,Long userId) {
        return page(page,new LambdaQueryWrapper<WorkIssue>()
                                            .eq(WorkIssue::getUserId,userId)
//                                            .eq(WorkIssue::getStatus,1)
        );
    }
}
