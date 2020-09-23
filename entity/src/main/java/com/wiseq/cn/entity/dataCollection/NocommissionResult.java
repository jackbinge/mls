package com.wiseq.cn.entity.dataCollection;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class NocommissionResult {
    private String billNumber;
    private String adminOrgName;
    private String productModel;
    private String productName;
    private String createTime;
    private String qty;
    private String remak;
    private String productId;
    private String bomId;
    private Combine combine;
}
