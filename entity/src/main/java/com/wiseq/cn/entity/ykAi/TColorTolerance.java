package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.Date;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/6      jiangbailing      原始版本
 * 文件说明:基础库-色容差
 */
@Data
public class TColorTolerance {
    /**
     * 色区名称，色块色区名称
     */
    private String name;


    private Long id;

    /**
     * 色区详情
     */
    private Long dtlId;

    /**
     * 色区形状 0 椭圆 1四边 只针对色容差色区，色块类型类型色区该字段为空
     */
    private Byte shape;


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

    /**
     * 椭圆长轴
     */
    private Double a;

    /**
     * 椭圆短轴 x
     */
    private Double b;

    /**
     * 椭圆中心点 x
     */
    private Double x;

    /**
     * 椭圆中心点 y
     */
    private Double y;

    /**
     * 椭圆倾斜角度
     */
    private Double angle;

    /**
     * 创建时间
     */
    private Date createTime;

    /**
     * false、true 删除
     */
    private Boolean isDelete;
}
