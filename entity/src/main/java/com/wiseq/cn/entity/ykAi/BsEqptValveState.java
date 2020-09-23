package com.wiseq.cn.entity.ykAi;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/21     jiangbailing      原始版本
 * 文件说明:  工单状态设备表
 */
@ApiModel(value="工单状态设备表")
@Data
public class BsEqptValveState implements Serializable {

    @ApiModelProperty(value="主键")
    private Long id;

    /**
     * 任务状体id
     */
    @ApiModelProperty(value="任务状体id")
    private Long taskStateId;

    /**
     * 设备阀体id
     */
    @ApiModelProperty(value="设备阀体id")
    private Long eqptValveId;

    /**
     * 设备阀体状态定义
     */
    @ApiModelProperty(value="设备阀体状态定义")
    private Long eqptValveDfId;

    /**
     * 创建时间
     */
    @ApiModelProperty(value="创建时间")
    private String createTime;

}