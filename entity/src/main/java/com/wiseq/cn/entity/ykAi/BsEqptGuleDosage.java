package com.wiseq.cn.entity.ykAi;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.util.Date;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/23     jiangbailing      原始版本
 * 文件说明: 点胶设定参数对应点胶设定参数表
 */
@Data
public class BsEqptGuleDosage {
    @ApiModelProperty(value="null")
    private Long id;



    @ApiModelProperty(value="任务单id")
    private Long taskId;

    @ApiModelProperty(value="任务单状态 id")
    private Long taskStateId;


    @ApiModelProperty(value="设备阀体id")
    private Long eqptValveId;


    @ApiModelProperty(value="点胶用量")
    private Double dosage;


    @ApiModelProperty(value="创建时间")
    private Date createTime;


    @Override
    public String toString() {
        return "BsEqptGuleDosage{" +
                "id=" + id +
                ", taskId=" + taskId +
                ", taskStateId=" + taskStateId +
                ", eqptValveId=" + eqptValveId +
                ", dosage=" + dosage +
                ", createTime=" + createTime +
                '}';
    }


}
