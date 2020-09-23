package com.wiseq.cn.entity.ykAi;

import lombok.Data;

@Data
public class TOutputRequireBeforeTestRule {
    /**
     * 前测规则和出货要求的中间表ID
     */
    private Long id;

    /**
    * 前测规则id
    */
    private Long beforeTestRuleId;

    /**
    * 出货要求id
    */
    private Long outputRequireId;

    /**
    * 规则类型 0 对应单层工艺，2 对应多层工艺上层 1 对应多层工艺下层
    */
    private Byte ruleType;

    /**
     * 是否删除
     */
    private Boolean isDelete;

    /**
     * 前测规则
     */
    private TBeforeTestRule tBeforeTestRule;

}