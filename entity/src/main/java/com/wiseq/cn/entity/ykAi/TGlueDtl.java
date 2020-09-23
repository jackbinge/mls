package com.wiseq.cn.entity.ykAi;

import java.util.Date;

import lombok.Builder;
import lombok.Data;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/31       lipeng      原始版本
 * 文件说明:  原材料库-胶水详情表
 */
@Data
public class TGlueDtl {
    private Long id;

    /**
    * 外键关联胶水表主键
    */
    private Long glueId;

    /**
    * 胶水类型 A胶或B胶
    */
    private String glueType;

    /**
    * 胶水编码
    */
    private String glueCode;

    /**
    * 胶水规格
    */
    private String glueSpec;

    /**
    * 供应商
    */
    private String supplier;

    /**
    * 粘度最大值
    */
    private Double viscosityMax;

    /**
    * 粘度最小值
    */
    private Double viscosityMin;

    /**
    * 硬度最大值
    */
    private Double hardnessMax;

    /**
    * 硬度最小值
    */
    private Double hardnessMin;

    /**
    * 密度
    */
    private Double density;

    /**
    * 创建时间
    */
    private Date createTime;
}