package com.wiseq.cn.ykAi.dao;


import com.wiseq.cn.entity.ykAi.TTypeMachine;
import com.wiseq.cn.entity.ykAi.TypeMachineForTest;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/30       jiangbailing      原始版本
 * 文件说明:  基础数据库-机台信息
 */
public interface TTypeMachineDao {
    /**
     * 删除数据通过主键
     *
     * @param id
     * @return
     */
    int deleteByPrimaryKey(Long id);


    /**
     * 插入数据有非null验证
     *
     * @param record
     * @return
     */
    int insertSelective(TTypeMachine record);

    /**
     * 通过主键修改有字段非null验证
     *
     * @param record
     * @return
     */
    int updateByPrimaryKeySelective(TTypeMachine record);

    /**
     * 通过主键修改是否禁用
     *
     * @param record
     * @return
     */
    int updateOnAndOff(TTypeMachine record);

    /**
     * 修改胶体高度
     * @param typeMachineId
     * @param guleHightUsl
     * @param guleHightLsl
     * @return
     */
    int updateTypeMachineGlueHigh(@Param("typeMachineId") Long typeMachineId, @Param("guleHightUsl") Double guleHightUsl, @Param("guleHightLsl") Double guleHightLsl);

    /**
     * 通过主键获取机种信息
     *
     * @param id
     * @return
     */
    TTypeMachine selectByPrimaryKey(Long id);


    /**
     * @param spec
     * @param processType
     * @param disabled
     * @return
     */
    List<TTypeMachine> selectAll(@Param("spec") String spec, @Param("processType") Byte processType, @Param("disabled") Boolean disabled);


    /**
     * 通过规格获取机种list非模糊查询
     *
     * @param spec
     * @return
     */
    List<TTypeMachine> findTTypeMachineBySpec(@Param("spec") String spec);

    /**
     * @param spec
     * @param processType
     * @param disabled
     * @param crystalNumber
     * @return
     */
    List<TTypeMachine> findList(@Param("spec") String spec,
                                @Param("processType") Byte processType,
                                @Param("disabled") Boolean disabled,
                                @Param("crystalNumber") Integer crystalNumber);


    /**
     * 获取测试规则库首页列表
     *
     * @param spec
     * @param processType
     * @return
     */
    List<TypeMachineForTest> findTypeMatchineListForTest(@Param("spec") String spec,
                                                         @Param("processType") Byte processType,
                                                         @Param("crystalNumber") Integer crystalNumber);


    /**
     * 通络机种id获取机种信息
     *
     * @param typeMachineId
     * @return
     */
    TTypeMachine findTypeMachineById(@Param("typeMachineId") Long typeMachineId);


}