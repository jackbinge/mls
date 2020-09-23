package com.wiseq.cn.ykAi.dao;

import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/14     jiangbailing      原始版本
 * 文件说明: 生产搭配对应的芯片波段
 */
public interface TModelBomChipWlRankDao {
    Integer insert(@Param("list") List<Long> list, @Param("modelBomId") Long modelBomId);

    /**
     * 通过modelid获取对应的芯片波段数据(芯片和所选波段信息)
     * @param modelId
     * @return
     */
    List<Map<String, Object>> selectAiModelChipInfo(@Param("modelId") Long modelId);


    List<Map<String, Object>> selectChipWlRankIdList(@Param("modelBomChipWlRankIdList") String modelBomChipWlRankIdList);
}
