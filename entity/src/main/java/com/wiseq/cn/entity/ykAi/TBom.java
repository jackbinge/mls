package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * 机种库BOM表
 * @author jiangbailing
 */
@Data
public class TBom implements Serializable {
    private Long id;

    /**
     * 机种id
     */
    private Long typeMachineId;

    /**
     * 机种规格
     */
    private String typeMachineSpec;

    /**
     * bom编码
     */
    private String bomCode;

    /**
     * 芯片
     */
    //private Long chipId;

    /*芯片规格
     */
    private String chipSpec;


    /**
     * 支架
     */
    private Long scaffoldId;

    /*支架规格
     */
    private String scaffoldSpec;

    /**
     * 胶水
     */
    private Long glueId;

    /**
     * a胶水规格
     */
    private String aguleSpec;

    /**
     * a胶的的id
     */
    private Long aglueId;

    /**
     * b胶水规格u
     */
    private String bguleSpec;

    /**
     * b胶的Id
     */
    private Long bglueId;

    /**
     * 扩散粉
     */
    private Long diffusionPowderId;

    /**
     * 扩散粉规格
     */
    private String diffusionPowderSpec;

    /**
     * 抗沉淀粉
     */
    private Long antiStarchId;

    /**
     * 抗沉淀粉规格
     */
    private String antiStarchSpec;

    /**
     * 创建时间
     */
    private Date createTime;

    /**
     * bom 类型，flase 正常,true 临时
     */
    private Boolean isTemp;

    /**
     * bom类型 0 对应单层工艺，1 对应多层工艺上层 2 对应多层工艺下层
     */
    private Byte bomType;

    /**
     * 备注
     */
    private String remark;

    /**
     * 荧光粉列表
     */
    private List<TPhosphor> tPhosphors;

    /**
     * 芯片波段ID
     */
    //private Long chipWlRankId;
    /**
     * 芯片波段范围-最大值
     */
    private double wlMax;

    /**
     * 芯片波段范围-最小值
     */
    private double wlMin;

    /**
     * 芯片列表
     */
    private List<TBomChip> chipList;

    /**
     * 必用的荧光粉id
     */
    private String mustUsePhosphorId;

    /**
     * 禁止使用的荧光粉的id
     */
    private String prohibitedPhosphorId;

    /**
     * 限制使用的荧光粉类型
     */
    private String limitPhosphorType;

    /**
     * bom的来源
     */
    private Integer bomSource;
}