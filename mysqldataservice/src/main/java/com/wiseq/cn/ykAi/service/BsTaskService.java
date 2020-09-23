package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.*;
import io.swagger.annotations.ApiOperation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/21     jiangbailing      原始版本
 * 文件说明:
 */

public interface BsTaskService {
    /**
     * 获取工单列表
     * @param taskCode
     * @param type
     * @param groupId
     * @param typeMachineSpec
     * @param stateFlag
     * @param pageNum
     * @param pageSize
     * @return
     */
    Result InProductTaskList(String taskCode,
                              Byte type,
                              Long groupId,
                             String typeMachineSpec,
                      Byte stateFlag,
                      Integer pageNum,
                      Integer pageSize);


    /**
     * 获取工单最新的阀体列表
     * @param taskStateId
     * @return
     */
    Result findTaskStateEqptValve(Long taskStateId);


    /**
     *
     * 获取工单详情之页面的配比
     * @param taskStateId
     * @return
     */
    Result judgeTaskFormulaList(Long taskStateId);


    /**
     * 工单关闭操作
     * 首先获取当前工单的状态数据
     * 1.新增工单状态表，修改工单状态表原来的数据
     * 2.工单关闭 设置为关闭 ，更新关闭时间bs_task
     * 3.复制阀体把阀体状体状态改为已关闭 bs_eqpt_valve_state
     * 4.删除阀体工单对应表里面的数据和此工单对应的数据bs_eqpt_task_runtime
     * 5.工单状态对阀体表设为已关闭
     *
     */
    @Transactional
    Result closeTask(Long taskStateId, Long userId);


    @Transactional
    Result addTaskFormulaForPage(EditTaskFormulaForPage editTaskFormulaForPage);

    @Transactional
    Result taskFormulaEdit(BsTaskFormulaForPage bsTaskFormulaForPage);

    @Transactional
    Result updateUseAdviceFormulaEdit(BsTaskFormulaForPage bsTaskFormulaForPage);

    /**
     * 获取可供选择的阀体
     * @param positon
     * @return
     */
    public Result  getListOfOptionsEqptValve(Integer positon);

    @Transactional
    Result beginSY(Long taskStateId, Long userId);


    @Transactional
    Result setNG(Long taskStateId, Long eqptValveId, Long userId,String judgementResult);

    @Transactional
    Result cancelNG(Long taskStateId, List<Long> eqptValveIdList, Long userId,Integer raRequire,Integer compulsoryPass,Integer updateChipArea);

    @Transactional
    Result testOk(Long taskStateId, Long eqptValveId, Long userId);


    @Transactional
    Result allDiscard(Long taskStateId, Long fileId, Long userId, Long eqptValveId);

    public Result getTaskDtl(Long taskStateId);



    @Transactional
    Result addTaskEqptValve(List<BsEqptGuleDosage> list);

    @Transactional
    Result closeTaskEqptValve(EqptValveClose eqptValveClose);

    @Transactional
    Result setEqptGlueDosage(BsEqptValveDosageEadit bsEqptValveDosageEadit);

    /**
     * 编辑工单的配方
     * 0.首先看工单状态
     * 1.查看是否存在这个配方，如果有直接关联
     * 2.如果没有则首先新建 然后返回ID
     * 3.根据工单状态来决定新增工单状态还是变更工单配方
     * @return
     */
    @Transactional
    Result editTaskAIModel(BsTaskAIModelEdit bsTaskAIModelEdit);

    /**
     * 推荐胶量
     * @param eqptValveId
     * @param taskId
     * @return
     */
    Result recommendGlueDosageMethod(Long eqptValveId, Long taskStateId);

    /**
     * 进入量产
     * @param taskId 工单ID
     * @param taskStateId 工单状态ID
     * @param userId 用户ID
     * @return
     */
    Result  goToLC(Long taskId, Long taskStateId, Long userId);


    /**
     * 用户选择数据源，系统推荐配比
     * 配比库中新荐配比，更新模型系数
     * @param selectModelId
     * @param selectTaskId
     * @param thisModelId
     * @return
     */
    public Result aiModelCustom(Long thisModelId,Long taskStateId,Long userId);


    /**
     * 模型数据源
     * 新模型的model_id
     * @param modelId
     * @param typeMachineSpec
     * @param tOutputCode
     * @param bomCode
     * @return
     */
    Result aiRecommendModelList(Long modelId,
                           String typeMachineSpec,
                           String tOutputCode,
                           String bomCode,
                           Integer pageNum,
                           Integer pageSize);


    /**
     * 推模型列表-工单列表
     * @param taskCode
     * @param groupId
     * @param taskType
     * @param modelId
     * @param pageNum
     * @param pageSize
     * @return
     */
    Result findAiRecommendTaskList(String taskCode,
                                   Long groupId,
                                   Byte taskType,
                                   Long modelId,
                                   Integer pageNum,
                                   Integer pageSize);

    /**
     * 系统修正配比
     * @param taskId
     * @param taskStateId
     * @param userId
     * @param raRequire
     * @return
     */
    @Transactional
    Result aiUpdateModel(Long taskId, Long taskStateId, Long userId,Integer raRequire);


    Result findTaskListByTypeModelId(Long modelId);


    Result checkoutAiModel(Long taskStateId);


    /**
     * 获取系统推荐需要的展示列表
     * @param taskId
     * @return
     */
    Result systemAdvice(Long taskStateId);

    /**
     * 获取上传文件后需要展示的判定类型
     * @param taskId
     * @param taskStateId
     * @return
     */
    Result getjudgementType(Long taskStateId);


    Result getCloseMainProcessTask(String taskCode,
                                   Byte type,
                                   Long groupId,
                                   String typeMachineSpec,
                                   Byte stateFlag,
                                   Integer pageNum,
                                   Integer pageSize);

    Result getNewestTaskStateId(Integer processType, Integer processVersion, Long taskId);


    Result getFilterBOMList(FilterBOMDataForPage filterBOMDataForPage);


    Result getjudagementTypeByFileId(Long fileId);

    @Transactional
    Result saveMixPowderWeight(ZConsumption zConsumption);

    Result getMixPowderWeight(Long taskId,Long taskStateId);

    //Result getConsumption(Long taskStateId);
    Result getSpAdvice(StartAdvice startAdvice);

}
