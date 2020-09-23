package com.wiseq.cn.entity.dataCollection;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class NoCommissioningWo {
    private String billNumber;//工单编号
    private String adminOrgName;//生产车间
    private String productModel;//机种规格
    private String productId;//机种id
    private String createTime;
    private String qty;//计划数量
    private String remak;
    private String exception;
}
