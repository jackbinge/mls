package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.Date;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/21     jiangbailing      原始版本
 * 文件说明: 设备阀体点胶参数
 */
@Data
public class EqptValveDosage {
    /**
     *主键ID
     */
   private Long id;
    /**
     * 工单状态ID
     */
   private Long  taskStateId;
    /**
     * 阀体ID
     */
   private Long eqptValveId;
    /**
     * 阀体状态ID
     */
   private Long eqptValveDfId;
    /**
     * 阀体状态名称
     */
   private String stateName;
    /**
     * 阀体状态设定值
     */
   private Byte stateFlag;
    /**
     * 创建时间
     */
   private Date create_time;
    /**
     * 阀体名称
     */
   private String eqptValveName;

    /**
     * 点胶参数
     */
   private Double dosage;

    /**
     * 是否判定
     */
    private Boolean isNoJudaged;
}
