package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/27     jiangbailing      原始版本
 * 文件说明:
 */
@Data
public class AiRecommendTaskListPage {
    /**工单
     *
     */
    private Long taskId;
    /**工单编码
     *
     */
    private String taskCode;
    /**工单类型
     *
     */
    private Byte type;

    /**
     * 工单类型名字
     *
     */
    private String typeName;

    /** 备注
     *
     */
    private String easRemak;

    /**
     * 组织名称
     */
    private String groupName;

    /**
     * 组织ID
     */
    private Long groupId;
    /** 机种规格
     *
     */
    private String typeMachineSpec;
    /** 机种ID
     *
     */
    private Long  typeMachineId;

    /**
     * 机种名称
     */
    private String typeMachineName;
}
