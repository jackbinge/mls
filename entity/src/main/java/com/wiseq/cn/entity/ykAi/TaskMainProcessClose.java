package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/6/3     jiangbailing      原始版本
 * 文件说明:
 */
@Data
public class TaskMainProcessClose {
    private String taskCode;
    private Integer type;//工单类型
    private String  typeMachineName;
    private String typeName;
    private String typeMachineSpec;
    private Long typeMachineId;
    private Long taskId;
    private Long taskStateId;
    private Long taskStateDfId;
    private String stateName;
    private Long stateFlag;
    private String groupName;
    private Long groupId;
    private String closeTime;
    private String remark;
    private Integer processClass;
    private Integer processVersion;
}
