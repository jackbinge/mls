package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.Date;
/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       jiangbailing     原始版本
 * 文件说明:  AB胶展示列表
 */
@Data
public class TABGlue {
    private  Long id;
    /**
     * 胶水 A胶
     */
    private String aGlueSpec;
    /**
     * 胶水 A胶ID
     */
    private Long aGlueId;


    /**
     * 胶水 B胶水
     */
    private String bglueSpec;

    /**
     * 胶水 B ID
     */
    private Long bGlueId;

    /**
     * 固定比例a
     */
    private Double ratioA;

    /**
     * 固定比例b
     */
    private Double ratioB;

    /**
     * 创建时间
     */
    private Date createTime;

    /**
     * false 正常、true 删除
     */
    private Boolean isDelete;

    /**
     * 是否禁用 false 不禁用 true 禁用
     */
    private Boolean disabled;

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

}
