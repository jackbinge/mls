package com.wiseq.cn.entity.dataCollection;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class EasWo {

    private Integer id;
    private String billId;//生产订单ID
    private String billNumber;//生产订单编码
    private String bizDate;//业务日期
    private String status;//状态
    private String storageId;//库存组织ID
    private String storageNumber;//库存组织编码
    private String storageName;//库存组织名称
    private String adminOrgId;//部门ID
    private String adminOrgNumber;//部门编码
    private String adminOrgName;//部门名称
    private String productId;//产品ID
    private String productNumber;//产品编码
    private String productName;//产品名称
    private String productModel;//产品规格型号
    private String ttypeNumber;//事务类型编码
    private String ttypeName;//事务类型名称
    private String bizTypeNumber;//BOM编码
    private String bizTypeName;//订单数量
    private String bomNumber;//Bom编码
    private String qty;//订单数量
    private String inWarehQty;//订单已入库数量
    private String planBeginDate;//计划开工日期
    private String planEndDate;//计划完工日期
    private String feedException;//投料是否异常,存放异常原因，如果为null没有异常，可以投产,不为null,有异常
    private String groupId;//组织ID
    private List<EntryList> entryList;
}
