package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/6/3     jiangbailing      原始版本
 * 文件说明:
 */
@Data
public class TaskSampleProcessClose {
    private String taskCode;
    private Long taskStateId;
    private Long taskId;
    private String stateName;
    private Integer stateFlag;
    private String reason;
    private String closeTime;
    private String groupName;
    private Long groupId;
    private Long typeMachineId;
    private String typeMachineSpec;
    private Integer processClass;
    private Integer processVersion;
}
