package com.wiseq.cn.entity.dataCollection;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class EntryList {

    private Integer woId; //工单ID
    private String entryId;//分录ID
    private String parentId;//生产订单ID
    private String materialId;//生产订单ID
    private String materialNumber;//物料编码
    private String materialName;//物料名称
    private String materialModel;//规格型号
    private String unitName;//计量单位
    private String standardQty;//标准用量
    private String reqQty;//需求数量
    private String unitQty;//单位用量
    private String issueQty;//已领料数量
    private String returnQty;//退料数量
    private String canIssueQty;//可领料数量
    private Integer materialClass;//物料类型，null 未知,0芯片  1胶水 2 荧光粉 3 支架 4扩散粉 5抗沉淀粉
}
