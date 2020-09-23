package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/12      jiangbailing      原始版本
 * 文件说明:基础库-配比编辑所需实体
 */
@Data
public class EditTModelFormulaForPage {
    /**
     * 修改配比记录
     */
    private  BsFormulaUpdateLog bsFormulaUpdateLog;

    /**
     * 配比修改详情
     */
    private List<TModelFormulaForTables> tModelFormulaForTables;
}
