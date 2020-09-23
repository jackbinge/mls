package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/21     jiangbailing      原始版本
 * 文件说明: 设备阀体
 */
@Data
public class BSTaskEqptValve {
    /**
     * 组织名
     */
    private String groupName;
    /**
     * 组织ID
     */
    private Long groupId;
    /**
     * 设备ID
     */
    private Long eqptId;
    /**
     * 资产编码
     */
    private String assetsCode;
    /**
     * 位置编码
     */
    private Integer positon;

    /**
     * 阀体参数表
     */
    List<EqptValveDosage> eqptValveDosageList;


}
