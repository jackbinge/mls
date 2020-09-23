package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/13      jiangbailing      原始版本
 * 文件说明:后台管理---物料和规则的映射关系用于页面展示
 */
@Data
public class MaterialTypeMapForPage {
    /**
     * 物料类型，0芯片  1胶水 2 荧光粉 3 支架 4扩散粉 5抗沉淀粉
     */
    private Byte materalType;

    /**
     * 物料名称
     */
    private String typeName;

    /**
     * 对应的规则列表
     */
    private List<MaterialTypeRule> materialTypeRules;
}
