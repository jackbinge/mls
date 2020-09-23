package com.wiseq.cn.entity.ykAi;

import lombok.Data;

@Data
public class TSpcRule {
    private Long id;

    /**
    * 机种ID
    */
    private Long typeMachineId;

    /**
    * 质控点 0 落bin率 ,1 △x和△y
    */
    private Byte qcPoint;

    /**
    * 控制上线,只针对良率
    */
    private Double ucl;

    /**
    * 控制下线,只针对良率
    */
    private Double lcl;

    /**
    * 控制上线,只针对距离，x
    */
    private Double deltaXUcl;

    /**
    * 控制下线,只针对距离，x
    */
    private Double deltaXLcl;

    /**
    * 控制上线,只针对距离，y
    */
    private Double deltaYUcl;

    /**
    * 控制下线,只针对距离，y
    */
    private Double deltaYLcl;

    /**
    * 控制限设定方式 0 理论计算，1人工设定
    */
    private Byte clOptional;

    /**
    * 是否禁用 false 不禁用 true 禁用
    */
    private Boolean disabled;

}