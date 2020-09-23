package com.wiseq.cn.ykAi.dao;


import com.wiseq.cn.entity.ykAi.TTypeMachineGuleHigh;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/30       jiangbailing      原始版本
 * 文件说明:  机种库-胶体高度
 */
public interface TTypeMachineGuleHighDao {
    /**
     * 删除通过主键
     * @param id
     * @return
     */
    int deleteByPrimaryKey(Long id);


    /**
     * 获取胶体高度
     * @param typeMachineId
     * @return
     */
    List<TTypeMachineGuleHigh> selectAllByTypeMachineId(@Param("typeMachineId") Long typeMachineId);

    /**
     * 新增无验证
     * @param record
     * @return
     */
    int insert(TTypeMachineGuleHigh record);

    /**
     * 新增有验证
     * @param record
     * @return
     */
    int insertSelective(TTypeMachineGuleHigh record);

    /**
     * 通过主键查询
     * @param id
     * @return
     */
    TTypeMachineGuleHigh selectByPrimaryKey(Long id);

    /**
     * 修改加验证
     * @param record
     * @return
     */
    int updateByPrimaryKeySelective(TTypeMachineGuleHigh record);

    /**
     * 修改不加验证
     * @param record
     * @return
     */
    int updateByPrimaryKey(TTypeMachineGuleHigh record);
}