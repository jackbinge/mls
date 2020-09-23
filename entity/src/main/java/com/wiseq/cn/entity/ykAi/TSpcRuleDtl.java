package com.wiseq.cn.entity.ykAi;

import lombok.Data;

@Data
public class TSpcRuleDtl {
    private Long id;

    /**
    * 质控规则
    */
    private Long qcRuleId;

    /**
    * 预警规则ID 新增时要传
    */
    private Long baseRuleId;

    //新增时要传
    private Integer m;

    //新增时要传
    private Integer n;
}