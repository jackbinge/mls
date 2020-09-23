package com.wiseq.cn.entity.webview;

import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;

/**
 * 版本        修改时间        编者      备注
 * V1.0        ------        jpdong    原始版本
 * 文件说明: 定时任务日志实体
 **/
@Setter
@Getter
public class TimerTaskLog {
    private Integer id;
    private Integer taskid;
    private Integer issucess;
    private String code;
    private String logContent;
    private Timestamp createTime;
    private String jobName;
}
