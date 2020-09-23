package com.wiseq.cn.entity.dataCollection;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CheckOuputRule {
    private Integer id;
    private Integer outputBeforRuleId;
    private Integer outputNbakeRuleId;
    private Integer productid;
    private String productModel;
}
