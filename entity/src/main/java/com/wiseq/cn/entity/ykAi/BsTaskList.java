package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/21     jiangbailing      原始版本
 * 文件说明: 工单列表
 */
@Data
public class BsTaskList {
    /**
     * 工单编码
     */
    private String taskCode;
    /**
     * 工单类型
     */
    private Integer type;
    /**
     * 机种名字
     */
    private String typeMachineName;
    /**
     * 工单类型名字
     */
    private String typeName;
    /**
     * 机种规格
     */
    private String typeMachineSpec;
    /**
     * 机种ID
     */
    private Long typeMachineId;
    /**
     * 工单id
     */
    private Long taskId;
    /**
     * 工单状态表ID
     */
    private Long taskStateId;
    /**
     * 工单状态定义表ID
     */
    private Long taskStateDfId;

    /**
     * 工单状态名字
     */
    private String stateName;

    /**
     * 状态值
     */
    private Integer stateFlag;

    /**
     * 组织机构名
     */
    private String groupName;

    /**
     * 组织机构ID
     */
    private Long groupId;

    /**
     * 是否有未判定的
     */
    private Boolean isNoJudged;

    /**
     * 备注
     */
    private String easRemak;
}
