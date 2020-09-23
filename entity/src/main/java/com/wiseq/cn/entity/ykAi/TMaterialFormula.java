package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/10      jiangbailing      原始版本
 * 文件说明:材料和配比关系表
 */
@Data
public class TMaterialFormula {
    /**
     * id
     */
    private Long materialId;

    /**
     * 波长
     */
    private Double peakWavelength;

    /**
     * 密度
     */
    private Double density;

    /**
     * 规格
     */
    private String spec;

    /**
     * 比值
     */
    private Double ratio;

    /**
     * 材料类型
     */
    private Integer materialClass;



    /**
     * 最高胶体高度
     */
    //private Double guleHightUsl;

    /**
     * 最低胶体高度
     */
    //private Double guleHightLsl;

    /**
    @Override
    public String toString() {
        return "TMaterialFormula{" +
                ", materialId=" + materialId +
                ", peakWavelength=" + peakWavelength +
                ", density=" + density +
                ", spec=" + spec +
                ", ratio=" + ratio +
                ", materialClass=" + materialClass +
                '}';
    }
    */


}
