package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.entity.ykAi.*;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/21     jiangbailing      原始版本
 * 文件说明: 工单各个阶段对应的生产配比
 */
public interface BsTaskFormulaDao {
    /**
     * A胶
     *
     * @param taskStateId
     * @param taskBomId
     * @return
     */
    TMaterialFormula getBsTaskFormulaGlueAByTaskFormulaId(@Param("taskStateId") Long taskStateId, @Param("taskBomId") Long taskBomId);

    /**
     * B胶
     *
     * @param taskStateId
     * @param taskBomId
     * @return
     */
    TMaterialFormula getBsTaskFormulaGlueBByTaskFormulaId(@Param("taskStateId") Long taskStateId, @Param("taskBomId") Long taskBomId);

    /**
     * 荧光粉
     *
     * @param taskStateId
     * @param taskBomId
     */
    List<TMaterialFormula> getBsTaskFormulaPhosphorsByTaskFormulaId(@Param("taskStateId") Long taskStateId, @Param("taskBomId") Long taskBomId);


    /**
     * @param taskStateId
     * @param taskBomId   3 抗沉淀粉
     */
    TMaterialFormula getBsTaskFormulaAntiStarchByTaskFormulaId(@Param("taskStateId") Long taskStateId, @Param("taskBomId") Long taskBomId);

    /**
     * 4 扩散粉
     *
     * @param taskStateId
     * @param taskBomId
     */
    TMaterialFormula getBsTaskFormulaDiffusionPowderTaskIdAndBomId(@Param("taskStateId") Long taskStateId, @Param("taskBomId") Long taskBomId);

    /**
     * 通过模型ID获取配比列表
     *
     * @param modelId
     * @return
     * --废弃
     */
    List<TModelFormula> findTModelFormula(@Param("modelId") Long modelId);


    /**
     * 批量新增 工单状态和 BOM表中间表
     * --废弃
     */
    Integer batchInsert(List<BsTaskFormula> list);

    /**
     * 新增
     *
     * @param bsTaskFormula
     * @return
     */
    Integer insertSelective(BsTaskFormula bsTaskFormula);


    /**
     * 删除工单模型表
     *
     * @param taskStateId
     * @param taskBomId
     * @return
     * --废弃
     */
    Integer deleteTaskModelFormula(@Param("taskStateId") Long taskStateId, @Param("taskBomId") Long taskBomId);

    /**
     * 删除工单配比详情表
     *
     * @param taskFormulaId
     * @return
     * --废弃
     */
    Integer deleteBsTaskFormulaDtlBytaskFormulaId(@Param("taskFormulaId") Long taskFormulaId);


    /**
     * 获取
     *
     * @param taskStateId
     * @param taskBomId
     * @return
     */
    BsTaskFormula getTaskFormula(@Param("taskStateId") Long taskStateId, @Param("taskBomId") Long taskBomId);


    /**
     * 工单状态ID
     *
     * @param taskStateId
     * @return
     */
    List<BsTaskFormula> getTaskFormulaForTaskState(@Param("taskStateId") Long taskStateId);


    /**
     * 工单状态
     *
     * @param taskStateId
     * @return
     */
    List<BsTaskFormulaMix> getBsTaskFormulaMix(@Param("taskStateId") Long taskStateId);


    /**
     * 工单状态
     *
     * @param taskStateId
     * @return
     */
    List<BsTaskFormulaMix> getTaskFormulaForTaskStateFromAiModel(@Param("taskStateId") Long taskStateId);

    /**
     * 验证当前状态是否有配比
     *
     * @param taskStateId
     * @return
     * --废弃
     */
    Integer isTaskformula(@Param("taskStateId") Long taskStateId);


    /**
     *
     * @param id task_formula_id
     * @return
     * --废弃
     */
    List<BsTaskFormulaDtl> getBsTaskFormulaDtl(@Param("id") Long id);
}
