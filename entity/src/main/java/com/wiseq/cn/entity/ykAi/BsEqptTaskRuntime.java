package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/24     jiangbailing      原始版本
 * 文件说明: 阀体工单热表
 */
@Data
public class BsEqptTaskRuntime {
    /**
     * 主键
     */
    private Long id;
    /**
     * 工单id
     */
    private Long taskId;
    /**
     * 阀体
     */
    private Long eqptValveId;
    /**
     * 创建时间
     */
    private String createTime;

}
