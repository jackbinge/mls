package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.entity.ykAi.*;
import org.apache.ibatis.annotations.Param;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/9/6     zhujiabin      原始版本
 * 文件说明: 工单状态设备表
 */
public interface BsZConsumptionDao {

    int saveMixPowderWeight(ZConsumption ZConsumption);

    int updateMixPowderWeight(ZConsumption ZConsumption);

    ZConsumption getMixPowderWeightBYtIdAndtsId(@Param(value = "taskId") Long taskId);
}
