package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/8      jiangbailing      原始版本
 * 文件说明:测试规则-非正常烤规则
 */
@Data
public class TOutputRequireNbakeRule {
    /**
     * 出货要求和非正常烤规则和
     */
    private Long id;

    /**
    * 非正常烤规则id
    */
    private Long noneBakeRuleId;

    /**
    * 出货要求id
    */
    private Long outputRequireId;

    /**
    * 规则类型 0 对应单层工艺，2 对应多层工艺上层 1 对应多层工艺下层
    */
    private Byte ruleType;

    /**
     * 分正常烤规则
     */
    private TNoneBakeTestRule tNoneBakeTestRule;
}