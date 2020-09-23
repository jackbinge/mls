package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.entity.ykAi.TIdAndNum;
import com.wiseq.cn.entity.ykAi.TTypeMachineDefaultSetFrontToBack;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/13     jiangbailing      原始版本
 * 文件说明:
 */
public interface TTypeMachineDefaultSetDao {
    public int insertDefaultChip(@Param("list") List<Integer> list, @Param("typeMachineId")Integer typeMachineId);

    int deleteDefaultChip(@Param("typeMachineId")Integer typeMachineId);

    int insertTypeMachineDefaultOtherMaterial(@Param("data") TTypeMachineDefaultSetFrontToBack data);

    int deleteTypeMachineDefaultOtherMaterial(@Param("typeMachineId")Integer typeMachineId);

    List<Map<String,Object>> getLimitPhosphorType(@Param("typeMachineId")Integer typeMachineId);

    List<Map<String,Object>> getDefaultChip(@Param("typeMachineId")Integer typeMachineId);

    Map<String,Object> getOtherDefault(@Param("typeMachineId")Integer typeMachineId);
}
