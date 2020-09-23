package com.wiseq.cn.entity.ykAi;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class TAiModel {
    private Long id;

    /**
    * 机种ID
    */
    private Long typeMachineId;

    /**
    * 机种色区ID
    */
    private Long colorRegionId;


    /**
    * 机种出货要求ID
    */
    private Long outputRequireMachineId;

    /**
     * 出货要要求
     */
    private TOutputRequirements tOutputRequirements;

    /**
    * false、true 删除
    */
    private Boolean isDelete;

    /**
    * 是否禁用 false 不禁用 true 禁用
    */
    private Boolean disabled;

    /**
    * 创建时间
    */
    private Date createTime;

    /**
    * 模型创建用户
    */
    private Long creator;

    /**
     * 芯片波段
     */
    //private List<TChipWlRank> tChipWlRankList;

    private List<Long> tChipWlRankList;

    /**
     * bom组合表
     */
    private List<TBom> tBoms;


}