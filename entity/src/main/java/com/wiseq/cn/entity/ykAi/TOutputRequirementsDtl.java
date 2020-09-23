package com.wiseq.cn.entity.ykAi;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class TOutputRequirementsDtl {
    //private Integer id;
    private Long id;

    /**
    * 出货要求id
    */
    private Long outputRequireId;

    /**
    * 中心点x, 对应与output_kind为1，2，1为调用算法计算，2为用户输入
    */
    private Double cpX;

    /**
    * 中心点y, 对应与output_kind为1，2，1为调用算法计算，2为用户输入
    */
    private Double cpY;

    /**
    * 类型，0 等于 、1 小于、 2 小于等于、 3大于、 4 大于等于，对应与output_kind为1时
    */
    private Double ratioType;

    /**
    * 比值 对应与output_kind为1时
    */
    private Double ratioValue;

    /**
    *  关联t_color_region_dtl 的id
    */
    private Long colorRegionDtlId;


    private Long colorRegionId;
    /**
     * 色区，色容差类型
     */
    private TColorRegion tColorRegion;

    /**
     * 色区详情表
     */
    private TColorRegionDtl tColorRegionDtl;

    /**
    * 创建时间
    */
    private Date createTime;
}