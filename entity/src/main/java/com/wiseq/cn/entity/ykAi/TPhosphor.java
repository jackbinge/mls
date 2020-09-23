package com.wiseq.cn.entity.ykAi;

import java.util.Date;
import lombok.Data;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:  原材料库-荧光粉
 */
@Data
public class TPhosphor {
    private Long id;

    /**
    * 荧光粉编码
    */
    private String phosphorCode;

    /**
    * 荧光粉规格
    */
    private String phosphorSpec;

    /**
    * 供应商
    */
    private String supplier;

    /**
    * 冷热比
    */
    private Double coldHeatRatio;

    /**
    * 粒径10
    */
    private Double particleDiameter10;

    /**
    * 粒径50
    */
    private Double particleDiameter50;

    /**
    * 粒径90
    */
    private Double particleDiameter90;

    /**
    * 峰值波长
    */
    private Double peakWavelength;

    /**
    * 密度
    */
    private Double density;

    /**
    * 色坐标_x
    */
    private Double cieX;

    /**
    * 色坐标_y
    */
    private Double cieY;

    /**
    * 半高宽
    */
    private Double fwhm;

    /**
    * 创建时间
    */
    private Date createTime;

    /**
     * false 正常、true 删除
     */
    private Boolean isDelete;

    /**
     * false 不禁用 true 禁用
     */
    private Boolean disabled;

    /**
     * 荧光粉类型名称
     */
    private String typeName;

    /**
     * 荧光粉类型ID
     */
    private Long phosphorTypeId;


}