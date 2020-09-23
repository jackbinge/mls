package com.wiseq.cn.entity.dataCollection;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/22     jiangbailing      原始版本
 * 文件说明: 投产时前端给后端传的内容
 */
@Data
public class CommissioningFrontToBack {
    private Long modelId;//生产搭配ID
    private BillParm billParm;//要投产的工单信息
}
