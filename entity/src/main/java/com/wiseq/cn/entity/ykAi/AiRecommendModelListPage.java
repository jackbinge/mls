package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.Map;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/27     jiangbailing      原始版本
 * 文件说明:
 */
@Data
public class AiRecommendModelListPage {
    private Long modelId;

    /** 机种名称
     *
     */
    private String  typeMachineName;
    /** 工单类型名称
     *
     */
    private String   typeName;
    /** 机种规格
     *
     */
    private String typeMachineSpec;
    /** 机种ID
     *
     */
    private Long  typeMachineId;

    /** 芯片波段ID
     *
     */
    private Long chipWlRankId;
    /**
     *
     */
    private Double wlMin;
    /**
     *
     */
    private Double wlMax;
    /**
     * bomid
     */
    private Long bomId;
    /**
     * bom 编码
     */
    private String bomCode;
    /** 出货要求编码
     *
     */
    private String tOutputCode;

    /**
     * bom
     */
    private TBom tBom;

    /**
     * 出货要求ID
     */
    private Long outputRequireMachineId;

    /**
     * 出货要求
     */
    private  TOutputRequirements tOutputRequirements;

    /**
     * 长度
     */
    private Integer maxLength;

    /**
     * 出货要求参数
     */
    private Map<String,String> outputRequireParams;
}
