package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.io.Serializable;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/30       jiangbailing      原始版本
 * 文件说明:  机种库-胶体高度
 */
@Data
public class TTypeMachineGuleHigh implements Serializable {
    private Long id;

    /**
     * 机种id
     */
    private Long typeMachineId;

    /**
     * 胶体高度上限
     */
    private Double guleHightUsl;

    /**
     * 胶体高度下限
     */
    private Double guleHightLsl;

    /**
     * 胶体高度类型，0 用于单层工艺，1用于双从工艺
     */
    private Byte processType;

    /**
     * 层次,null 为单层，0 整体胶高 1 底层胶高
     */
    private Byte layer;


}