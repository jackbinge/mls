package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/10      jiangbailing      原始版本
 * 文件说明:基础库-配比库
 */
@Data
public class TModelFormula {
    /**
     * bom组合编码
     */
    private Long bomId;

    /**
     * 模型ID
     */
    private Long modelId;

    /**
     * BOM类型
     */
    private Byte bomType;

    /**
     * 获取芯片范围ID
     */
    private Long chipWlRankId;

    /**
     * 配方id
     */
    private Long modelBomId;


    /**
     *胶体高度
     */
    private TScaffold scaffold;


    /**
     *胶体高度
     */
    private TTypeMachineGuleHigh guleHigh;


    /**
     * A胶胶水材料配比表中的配比
     */
    private TMaterialFormula glueAMaterial;


    /**
     * B胶胶水材料比例配比表中的配比
     */
    private TMaterialFormula glueBMaterial;


    /**
     * 抗沉淀粉材料比例配比表中的配比
     */
    private TMaterialFormula antiStarchMaterial;


    /**
     * 扩散粉材料比例配比表中的配比
     */
    private TMaterialFormula diffusionPowderMaterial;

    /**
     * 荧光粉
     */
    private List<TMaterialFormula> tPhosphors;


    /**
     * 各粉耗用
     */
    private List<ZConsumption> zConsumptions;





}
