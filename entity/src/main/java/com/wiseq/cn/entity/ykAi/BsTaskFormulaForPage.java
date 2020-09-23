package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/22     jiangbailing      原始版本
 * 文件说明: 工单配比编辑
 */
@Data
public class BsTaskFormulaForPage {
    /**
     * 工单ID
     */
    private Long taskId;
    /**
     * 工单状态ID
     */
    private Long taskStateId;
    /**
     * bomID
     */
    private Long bomId;

    /**
     * 用户ID
     */
    private Long userId;
    /**
     * 配比信息ID
     */
    private List<BsTaskFormulaDtl> bsTaskFormulaDtlList;


    @Override
    public String toString() {
        return "BsTaskFormulaForPage{" +
                "taskId=" + taskId +
                ", taskStateId=" + taskStateId +
                ", bomId=" + bomId +
                ", userId=" + userId +
                ", bsTaskFormulaDtlList=" + bsTaskFormulaDtlList +
                '}';
    }
}
