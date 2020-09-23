package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.entity.ykAi.TAlgorithmModel;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/9/21     zhujiabin      原始版本
 * 文件说明: 工单状态设备表
 */
public interface TAlgorithmModelDao {

    List<TAlgorithmModel> selectTAlgorithmModel();

    int updateTAlgorithmMode(TAlgorithmModel tAlgorithmModel);

    int addTAlgorithmMode(TAlgorithmModel tAlgorithmModel);
}
