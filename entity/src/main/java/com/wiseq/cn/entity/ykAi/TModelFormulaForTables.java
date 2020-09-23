package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/11      jiangbailing      原始版本
 * 文件说明:基础库-配表
 */
@Data
public class TModelFormulaForTables {

    private Long id;



    /**
     * 配方id
     */
    private Long modelBomId;

    /**
     * a胶，b胶，荧光粉、抗成淀粉、扩散粉
     */
    private Long materialId;

    /**
     * 比值
     */
    private Double ratio;

    /**
     * 物料类型 0 A胶，1 B胶，2 荧光粉，3 抗沉淀粉，4 扩散粉
     */
    private Byte materialClass;


    @Override
    public String toString() {
        return "TModelFormulaForTables{" +
                "id=" + id +
                ", modelBomId=" + modelBomId +
                ", materialId=" + materialId +
                ", ratio=" + ratio +
                ", materialClass=" + materialClass +
                '}';
    }


}
