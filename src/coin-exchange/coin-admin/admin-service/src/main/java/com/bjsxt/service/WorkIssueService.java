package com.bjsxt.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.bjsxt.domain.WorkIssue;
import com.baomidou.mybatisplus.extension.service.IService;
public interface WorkIssueService extends IService<WorkIssue>{


    /**
     * 条件分页查询工单列表
     * @param page
     *  分页参数
     * @param status
     * 工单的状态
     * @param startTime
     * 查询的工单创建起始时间
     * @param endTime
     * 查询的工单创建截至时间
     * @return
     */
    Page<WorkIssue> findByPage(Page<WorkIssue> page, Integer status, String startTime, String endTime);


    /**
     * 前台系统查询客户工单
     * @param page
     * @param  userId 会员的Id
     *
     * @return
     */
    Page<WorkIssue> getIssueList(Page<WorkIssue> page,Long userId);
}
