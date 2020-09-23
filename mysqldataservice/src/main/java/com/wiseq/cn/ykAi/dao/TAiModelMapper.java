package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.entity.ykAi.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/7      jiangbailing      原始版本
 * 文件说明:基础库-配比库
 */
public interface TAiModelMapper {
    /**
     * 删除配比
     *
     * @param id
     * @return
     */
    int deleteByPrimaryKey(Long id);

    /**
     * 获取用这个配比的工单数量
     *
     * @param modelId
     * @return
     */
    int findTaskNumWithThisModel(@Param("modelId") Long modelId);

    int insertSelective(TAiModel record);

    TAiModel selectByPrimaryKey(Long id);


    /**
     * 获取配比首页列表
     *
     * @param spec
     * @param processType
     * @return
     */
    List<LinkedHashMap<String, Object>> findModelList(@Param("spec") String spec, @Param("processType") Byte processType);


    /**
     * 新增model和bom关联表
     *
     * @return
     */
    int insertTModelBom(TModelBom tModelBom);


    /*String findTAiModel(@Param("modelId") Long modelId);*/


    /**
     * 通过模型ID获取配比列表
     *
     * @param modelId
     * @return
     */
    List<TModelFormula> findTModelFormula(@Param("modelId") Long modelId);


    /**
     * 通过模型ID获取模型对应的BOMlist
     *
     * @return
     */
    List<TBom> findBomByModelId(@Param("modelId") Long modelId);


    /**
     * 获取bomlist
     *
     * @param modelId
     * @return
     */
    List<TBom> findBomByModelIdOrderBy(@Param("modelId") Long modelId);

    /**
     * 获取荧光粉列表
     *
     * @param bomId
     * @return
     */
    List<TPhosphor> selectPhosphorByBomIdOrderBy(@Param("bomId") Long bomId, @Param("orderByList") List<TMaterialFormula> orderByList);


    /**
     * 通过出货要求id获取出货要求需要的色区详情列表
     *
     * @param outputRequireId
     * @return
     */
    List<TColorRegionDtl> outputRequiremendtlsByOutRequireId(@Param("outputRequireId") Long outputRequireId);


    /**
     * 获取荧光粉列表
     *
     * @param bomId
     * @return
     */
    List<TMaterialFormula> selectPhosphorByBomIdReturn(@Param("bomId") Long bomId);

    /**
     * 获取生产搭配列表
     *
     * @param typeMachineId
     * @param outputRequireMachineCode
     * @param bomCode
     * @return
     */
    List<TAIModelDtl> findMoldeList(@Param("typeMachineId") Long typeMachineId,
                                    @Param("outputRequireMachineCode") String outputRequireMachineCode,
                                    @Param("bomCode") String bomCode);

    /**
     * 通过模型Id去获取生产搭配
     *
     * @param modelId
     * @return
     */
    TAIModelDtl getOneMoldeByModelId(@Param("modelId") Long modelId);


    /**
     * 单个新增配比表
     *
     * @param tModelFormula
     * @return
     */
    int insertModelFormulaSelective(TModelFormulaForTables tModelFormula);


    /**
     * 批量修改
     *
     * @param list
     * @return
     */
    int updateBatchModelFormula(@Param("list") List<TModelFormulaForTables> list);

    /**
     * 单个修改
     *
     * @param tModelFormulaForTables
     */
    int updateModelFormula(TModelFormulaForTables tModelFormulaForTables);


    /**
     * A胶的配比
     *
     * @param bomId
     * @return
     */
    TMaterialFormula findMaterialGlueARatioByBomId(@Param("bomId") Long bomId);

    /**
     * B胶的配比
     *
     * @param bomId
     * @return
     */
    TMaterialFormula findMaterialGlueBRatioByBomId(@Param("bomId") Long bomId);

    /**
     * 抗沉淀粉
     *
     * @param bomId
     * @return
     */
    TMaterialFormula findMaterialAntiStarchRaitoByBomId(@Param("bomId") Long bomId);

    /**
     * 扩散粉
     *
     * @param bomId
     * @return
     */
    TMaterialFormula findMaterialDiffusionPowderRaitoByBomId(@Param("bomId") Long bomId);


    /**
     * 筛选除芯片波段外其它都相同的生产搭配
     *
     * @param typeMachineId
     * @param outputRequireMachineId
     * @param bomId
     * @return
     */
    List<Long> findAiModelIdList(
            @Param("typeMachineId") Long typeMachineId,
            @Param("outputRequireMachineId") Long outputRequireMachineId,
            @Param("bomId") Long bomId);


    /**
     * 获取需要的modelBom对应的芯片波段
     * @param modelId
     * @return
     */
    List<Long> findAiModelBomchipRankIdList(@Param("modelId") Long modelId);


    /**
     * 获取bom和模型表
     *
     * @param modelBomId
     * @return
     */
    TModelBom findModeBomByModelBomId(@Param("modelBomId") Long modelBomId);


    /**
     * 通过模型ID获取这个模型的详情 只限单层工艺
     *
     * @param modelId
     * @return
     */
    BsAIModelDtl findAiModelDtlByModelId(@Param("modelId") Long modelId);


    /**
     * @param outputRequireMachineId 出货要求Id
     * @param nowModelId             当前模型id
     * @return
     */
    Integer selectAiModelByOutputId(@Param("outputRequireMachineId") Long outputRequireMachineId, @Param("nowModelId") Long nowModelId);


    /**
     * 出货中心点
     *
     * @param x
     * @param y
     * @param outputRequireMachineId
     * @return
     */
    Integer updateOutputRequireCPXY(@Param("x") Double x, @Param("y") Double y, @Param("outputRequireMachineId") Long outputRequireMachineId);


    /**
     * 查看是否有配比
     *
     * @param modelId
     * @return
     */
    Integer findExitFormulaByModelId(@Param("modelId") Long modelId);


    /**
     * 通过模型ID获取器对应机种的目标参数
     */
    TargetParameter getTypeMachineTargetParameterByModelId(@Param("modelId") Long modelId);


    /**
     * 获取此模型bom所用的峰值波长列表
     * @return
     */
    List<PhosphorPeakWavelength> getBomPhosphorPeakWavelengthList(@Param("modelId") Long modelId);


    /**
     * 获取
     * @param modelId
     * @return
     */
    List<Map<String,Object>> findModelWithBom(@Param("modelId") Long modelId);


}