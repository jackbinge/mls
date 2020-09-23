package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/6      jiangbailing      原始版本
 * 文件说明:基础库-机种库-单个色块的信息
 */
@Data
public class TColorRegionOneSK {

    private Long id;
    /**
     * 色块名字
     */
    private  String name;
    /**
     * 此色块所在行数, 只针对色块色区，色容差色区该字段为空
     */
    private Integer xrow;

    /**
     * 此色块所在列数，只针对色块色区，色容差色区该字段为空
     */
    private Integer xcolumn;

    /**
     * 左上坐标 x1
     */
    private Double x1;

    /**
     * 左上坐标 y1
     */
    private Double y1;

    /**
     * 右上坐标 x2
     */
    private Double x2;

    /**
     * 右上坐标 y2
     */
    private Double y2;

    /**
     * 右下坐标 x3
     */
    private Double x3;

    /**
     * 右下坐标 y3
     */
    private Double y3;

    /**
     * 左下坐标 x4
     */
    private Double x4;

    /**
     * 左下坐标 y4
     */
    private Double y4;

}
