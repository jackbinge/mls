package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/11      jiangbailing      原始版本
 * 文件说明:基础库-生产搭配详情表
 */
@Data
public class TAIModelDtl {
    /**
     * 搭配ID
     */
    private Long id;

    /**
     * 机种ID
     */
    private Long typeMachineId;
    /**
     * 出货要求编码
     */
    private String outputRequireMachineCode;
    /**
     * 出货要求ID
     */
    private Long outputRequireMachineId;
    /**
     * 是否是临时
     */
    private Boolean isTemp;
    /**
     * 出货要求类型
     */
    private Byte outputKind;
    /**
     * 色区ID
     */
    private Long colorRegionId;
    /**
     * 色区名字
     */
    private String colorRegionName;
    /**
     * 中心点
     */
    private Double cpX;
    /**
     * 中心点
     */
    private Double cpY;
    /**
     * 最终时间
     */
    private String lastTime;

    /**
     * 组合列表bom列表
     */
    private List<TBom> bomList;

    /**
     * 获得配比列表
     */
    private List<TModelFormula> tModelFormulas;

    /**
     * 出货要求所需的色区/色块详情
     */
    private List<TColorRegionDtl> colorRegionDtls;
}
