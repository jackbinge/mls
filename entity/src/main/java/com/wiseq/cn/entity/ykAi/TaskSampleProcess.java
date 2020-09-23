package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/6/2     jiangbailing      原始版本
 * 文件说明:
 */
@Data
public class TaskSampleProcess {
    private String taskCode;//工单编码
    private String groupName;//生产车间编码
    private Long groupId;//生产车间ID
    private String typeMachineSpec;//机种规格
    private String initiateTime;//发起时间
    private Long typeMachineId;//机种ID
    private Long taskId;//工单ID
    private Long taskStateId;//工单状态ID
    private String reason;//打样原因
    private Integer stateFlag;//状态值
    private String stateName;//状态内容，显示用
    private Integer processClass;
    private Integer processVersion;
}
