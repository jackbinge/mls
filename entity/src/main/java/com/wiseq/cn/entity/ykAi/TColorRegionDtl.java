package com.wiseq.cn.entity.ykAi;

import java.util.Date;
import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/6     lipeng      原始版本
 * 文件说明:  色区明细
 */
@Data
public class TColorRegionDtl {
    private Long id;

    /**
    * 此色块所属色区ID
    */
    private Long colorRegionId;

    /**
    * 色块名称 如:A ， B ，C，只针对色块类型色区，色容差类型色区该字段为空
    */
    private String name;

    /**
    * 此色块所在行数，只针对色块类型色区，色容差类型色区该字段为空
    */
    private Integer xrow;

    /**
    * 此色块所在列数，只针对色块类型色区，色容差类型色区该字段为空
    */
    private Integer xcolumn;

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

    /**
     * 类型，0 等于 、1 小于、 2 小于等于、 3大于、 4 大于等于，对应与output_kind为1时
     */
    private Double ratioType;

    /**
     * 比值 对应与output_kind为1时
     */
    private Double ratioValue;

}