package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.*;
import org.apache.ibatis.annotations.Param;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/30       jiangbailing      原始版本
 * 文件说明:  基础库-机种库-出货要求
 */
public interface TOutputRequirementsDao {

    /**
     * 获取出货要求列表
     *
     * @param typeMachineId
     * @param outputKind
     * @param isTemp
     * @param code
     * @return
     */
    List<TOutputRequirements> selectByTypeMachineId(@Param("typeMachineId") Long typeMachineId,
                                                    @Param("outputKind") Byte outputKind,
                                                    @Param("isTemp") Boolean isTemp,
                                                    @Param("code") String code);

    /**
     * 通过id获取出货要求
     *
     * @param outputId
     * @return
     */
    TOutputRequirements selectByPK(@Param("outputId") Long outputId);

    /**
     * @param outputId
     * @return
     */
    TOutputRequirements selectByPKWithDelete(@Param("outputId") Long outputId);

    /**
     * 通过出货要求ID获取对应的出货名称
     *
     * @param outputRequireId
     * @return
     */
    TOutPutRequirementsColorRegion findTOutputRequirementsColorReginName(@Param("outputRequireId") Long outputRequireId);


    /**
     * 获取色块类型的列表
     *
     * @param outputRequireId
     * @return
     */
    List<TOutPutRequirementsColorSK> findTOutputRequirementsColorList(@Param("outputRequireId") Long outputRequireId);


    /**
     * 获取该机种下面的色容差列表
     *
     * @param typeMachineId
     * @return
     */
    List<TColorTolerance> findTColorTolerance(@Param("typeMachineId") Long typeMachineId);


    /**
     * 获取该机种下面的色块列表
     *
     * @param typeMachineId
     * @return
     */
    List<TColorRegionSK> findTColorRegionSKs(@Param("typeMachineId") Long typeMachineId);

    /**
     * 通过出货要求获取其详情
     *
     * @param outputRequireId
     * @return
     */
    List<TOutputRequirementsDtl> findTOutputRequirementsDtls(@Param("outputRequireId") Long outputRequireId);


    /**
     * 插入出货要求主表
     *
     * @param tOutputRequirements
     * @return
     */
    int insertSelective(TOutputRequirements tOutputRequirements);


    /**
     * @param id
     * @return
     */
    int deleteByPrimaryKey(@Param("id") long id);


    /**
     * 出货要求
     *
     * @param tOutputRequirements
     * @return
     */
    int updateByPrimaryKeySelective(TOutputRequirements tOutputRequirements);


    /**
     * 获取所有的色块信息包含已删除的
     *
     * @param typeMachineId
     * @return
     */
    List<TColorRegionSK> findAllTColorRegionSKs(@Param("typeMachineId") Long typeMachineId);


    /**
     * 获取这个机种所有的色块信息
     *
     * @param typeMachineId
     * @return
     */
    List<TColorTolerance> findAllTColorTolerance(@Param("typeMachineId") Long typeMachineId);


    /**
     * 获取这个Id对应的色区
     *
     * @param id
     * @return
     */
    TColorTolerance findAllTColorToleranceById(@Param("id") Long id);


    /**
     * 获取出货要求参数
     *
     * @return
     */
    Map<String,String> getOutputRequitementParams(@Param("outputId") Long outputId);


    /**
     * 修改t_output_requirements_dtl
     * @param dtl
     * @return
     */
    int updateDtlByPrimaryKeySelective(TOutputRequirementsDtl dtl);
}
