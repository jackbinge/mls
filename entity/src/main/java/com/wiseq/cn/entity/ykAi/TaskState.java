package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/19     jiangbailing      原始版本
 * 文件说明: 工单状态类
 */
@Data
public class TaskState {
    /**
     * 任务单ID
     */
    private Long taskId;
    /**
     * 任务单状态ID
     */
    private Long taskDfId;

    /**
     * 状态名字
     */
    private String stateName;

    /**
     * 状态编号
     */
    private Byte stateFlag;

    /**
     * 工单状态ID
     */
    private Long taskStateId;

    /**
     * 模型ID
     */
    private Long modelId;

    /**
     * 前测规则
     */
    private Long outputRequireBeforeTestRuleId;

    /**
     * 非正常烤规则
     *
     */
    private Long outputRequireNbakeRuleId;

    /**
     * 获取出货要求
     */
    private Long outputRequireMachineId;

    /**
     * 机种ID
     */
    private Long typeMachineId;

    /**
     * 机种规格
     */
    private String typeMachineSpec;

    /**
     * 0单层1双层
     */
    private Byte processType;

    /**
     * 备注
     */
    private String easRemak;

    /**
     * 投产时间
     */
    private String convertTime;

    private Boolean isRestSY;
}
