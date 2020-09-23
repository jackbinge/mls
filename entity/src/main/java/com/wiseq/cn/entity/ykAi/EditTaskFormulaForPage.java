package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/22     jiangbailing      原始版本
 * 文件说明: 工单配比新增和编辑
 */
@Data
public class EditTaskFormulaForPage {
    /**
     * 工单ID
     */
    private Long taskId;
    /**
     * 工单状态ID
     */
    private Long taskStateId;
    /**
     * 修改配比记录
     */
    private  BsFormulaUpdateLog bsFormulaUpdateLog;

    /**
     * 配比修改详情
     */
    private List<TModelFormulaForTables> tModelFormulaForTables;
}
