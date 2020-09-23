package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;
import java.util.List;


/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/30       jiangbailing      原始版本
 * 文件说明:  机种库
 */
@Data
public class TTypeMachine implements Serializable {
    private Long id;

    /**
     * 机种编码
     */
    private String code;

    /**
     * 机种规格
     */
    private String spec;

    /**
     * 显色指数,目标值
     */
    private Double raTarget;

    /**
     * 限制范围上限，用于算法显指良率统计
     */
    private Double raMax;

    /**
     * 显色指数下限，用于算法显指良率统计
     */
    private Double raMin;

    /**
     * R9
     */
    private Double r9;

    /**
     * 色温
     */
    private Integer ct;

    /**
     * 流明下限
     */
    private Double lumenLsl;

    /**
     * 流明上限
     */
    private Double lumenUsl;

    /**
     * 波长下限
     */
    private Double wlLsl;

    /**
     * 波长上限
     */
    private Double wlUsl;

    /**
     * 创建时间
     */
    private Date createTime;

    /**
     * 工艺类型，0单层工艺 1双层工艺
     */
    private Byte processType;

    /**
     * 备注
     */
    private String remark;

    /**
     * false正常、true 删除
     */
    private Boolean isDelete;

    /**
     * false正常、true 禁用
     */
    private Boolean disabled;

    /**
     * 色块数量
     */
    private Integer sKnum;

    /**
     * 色容差数量
     */
    private Integer sRcnum;


    /**
     * 胶体高度
     */
    private List<TTypeMachineGuleHigh> tTypeMachineGuleHigh;

    /**
     * 晶体数量
     */
    private Integer crystalNumber;

}