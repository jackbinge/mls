package com.wiseq.cn.entity.ykAi;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/21     jiangbailing      原始版本
 * 文件说明:  工单对应的配比
 */
@ApiModel(value="工单对应的BOM")
@Data
public class BsTaskFormula implements Serializable {

    @ApiModelProperty(value="null")
    private Long id;

    /**
     * 任务单状态 id
     */

    @ApiModelProperty(value="任务单状态 id")
    private Long taskStateId;

    /**
     * 任务单状态bom id,取当前任务单状态对应的model bom id
     */
    @ApiModelProperty(value="任务单状态bom id,取当前任务单状态对应的model bom id")
    private Long taskBomId;

}