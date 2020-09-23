package com.wiseq.cn.entity.ykAi;

import java.util.Date;
import java.util.List;

import lombok.Data;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/28       lipeng      原始版本
 * 文件说明:  原材料库-芯片
 */
@Data
public class TChip {
    private Long id;

    /**
     * 芯片编码
     */
    private String chipCode;

    /**
     * 芯片规格
     */
    private String chipSpec;

    /**
     * 芯片等级
     */
    private String chipRank;

    /**
     * 供应商
     */
    private String supplier;

    /**
     * 测试条件(非必填)
     */
    private String testCondition;

    /**
     * VF正向电压最大值
     */
    private Double vfMax;

    /**
     * VF正向电压最小值
     */
    private Double vfMin;

    /**
     * IV发光强度最大值
     */
    private Double ivMax;

    /**
     * IV发光强度最小值
     */
    private Double ivMin;

    /**
     * 波长最大值
     */
    private Double wlMax;

    /**
     * 波长最小值
     */
    private Double wlMin;

    /**
     * 亮度最大值
     */
    private Double lumenMax;

    /**
     * 亮度最小值
     */
    private Double lumenMin;

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
     * 勿动
     */
    private List<TChipWlRank> tChipWlRankList;


}