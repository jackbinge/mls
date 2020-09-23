package com.wiseq.cn.entity.ykAi;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import java.io.Serializable;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/21     jiangbailing      原始版本
 * 文件说明:  
 */
@ApiModel(value="工单对应的配比详情")
@Data
public class BsTaskFormulaDtl implements Serializable {
    @ApiModelProperty(value="null")
    private Long id;

    /**
     * 任务单状态 id
     */
    @ApiModelProperty(value="任务单状态与BOM关系表主键 id")
    private Long taskFormulaId;

    /**
     * 物料、芯片、支架，荧光粉、抗成淀粉、扩散粉
     */
    @ApiModelProperty(value="a胶，b胶，荧光粉、抗成淀粉、扩散粉 a胶和b胶对应的胶水详情表")
    private Long materialId;

    /**
     * 比值
     */
    @ApiModelProperty(value="比值")
    private Double ratio;

    /**
     *物料类型 0胶A，1胶水B,2 荧光粉，3 抗沉淀粉，4 扩散粉
     */
    @ApiModelProperty(value="物料类型 0胶A，1胶水B,2 荧光粉，3 抗沉淀粉，4 扩散粉")
    private Byte materialClass;

    /**
     * 波长
     */
    @ApiModelProperty(value="波长")
    private Double peakWavelength;

    /**
     * 密度
     */
    @ApiModelProperty(value="密度")
    private Double density;

    @ApiModelProperty(value="物料规格")
    private String spec;


    @Override
    public String toString() {
        return "BsTaskFormulaDtl{" +
                "id=" + id +
                ", taskFormulaId=" + taskFormulaId +
                ", materialId=" + materialId +
                ", ratio=" + ratio +
                ", materialClass=" + materialClass +
                ", peakWavelength=" + peakWavelength +
                ", density=" + density +
                ", spec= " + spec +
                '}';
    }
}