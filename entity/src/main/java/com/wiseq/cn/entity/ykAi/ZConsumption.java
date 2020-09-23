package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.io.Serializable;


/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2020/9/3    zhujiabin      原始版本
 * 文件说明:耗用
 */
@Data
public class ZConsumption implements Serializable {


    private Long id;

    //任务单id
    private Long taskId;
    //任务单状态id
    private Long taskStateId;

    //A胶耗用
    private Double glueAMaterial;
    //B胶耗用
    private Double glueBMaterial;
    //抗沉淀粉耗用
    private Double antiStarchMaterial;
    //扩散粉耗用
    private Double diffusionPowderMaterial;
    //荧光粉耗用
    private Double tphosphors0;

    private Double tphosphors1;

    private Double tphosphors2;

    private Double tphosphors3;

    private Double tphosphors4;
}
