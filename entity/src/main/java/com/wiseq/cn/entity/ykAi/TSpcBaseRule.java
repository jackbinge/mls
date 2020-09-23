package com.wiseq.cn.entity.ykAi;

import java.util.Date;
import lombok.Data;

@Data
public class TSpcBaseRule {
    private Long id;

    /**
    * 规则编号
    */
    private Integer ruleNo;

    /**
    * 规则模板
    */
    private String ruleTemplate;


    private Integer m;


    private Integer n;

    /**
    * 创建时间
    */
    private Date createTime;
}