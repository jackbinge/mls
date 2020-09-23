package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/6      jiangbailing      原始版本
 * 文件说明:基础库-机种库-出货要求
 */
@Data
public class TOutPutRequirementsColorSK {
    /**
     * 色块系列名称
     */
    private String name;
    /**
     * 色块名称
     */
    private String sname;
    /**
     * 中心点坐标X
     */
    private Double cpX;
    /**
     * 中心点坐标Y
     */
    private Double cpY;
    /**
     * 出货要求ID
     */
    private Long outputRequireId;
    /**
     * 比值类型 0 等于 、1 小于、 2 小于等于、 3大于、 4 大于等于，对应与output_kind为1时
     */
    private Double ratioType;
    /**
     * 比值
     */
    private Double ratioValue;
}
