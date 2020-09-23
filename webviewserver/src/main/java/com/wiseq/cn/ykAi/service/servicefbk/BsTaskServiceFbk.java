package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.*;
import com.wiseq.cn.ykAi.service.BsTaskService;
import io.swagger.annotations.ApiOperation;
import org.apache.xmlbeans.impl.xb.xsdschema.Public;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/24     jiangbailing      原始版本
 * 文件说明:
 */
@Service
public class BsTaskServiceFbk implements BsTaskService {
    @Override
    public Result InProductTaskList(String taskCode, Byte type, Long groupId, String typeMachineSpec, Byte stateFlag, Integer pageNum, Integer pageSize) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result findTaskStateEqptValve(Long taskStateId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result<TAIModelDtl> judgeTaskFormulaList(Long taskStateId) {

        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result closeTask(Long taskStateId, Long userId) {

        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result taskFormulaEdit(BsTaskFormulaForPage bsTaskFormulaForPage) {

        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result updateUseAdviceFormulaEdit(BsTaskFormulaForPage bsTaskFormulaForPage) {

        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getListOfOptionsEqptValve(Integer positon) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result beginSY(Long taskStateId, Long userId) {

        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result setNG(Long taskStateId, Long eqptValveId, Long userId, String judgementResult) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result cancelNG(Long taskStateId, String eqptValveIdList, Long userId, Integer raRequire, Integer compulsoryPass, Integer updateChipArea) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }


    @Override
    public Result testOk(Long taskStateId, Long eqptValveId, Long userId) {

        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result allDiscard(Long taskStateId, Long fileId, Long userId, Long eqptValveId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }


    @Override
    public Result getTaskDtl(Long taskStateId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result addFormulaEdit(EditTaskFormulaForPage editTaskFormulaForPage) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result addTaskEqptValve(List<BsEqptGuleDosage> list) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result closeTaskEqptValve(EqptValveClose eqptValveClose) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }


    @Override
    public Result setEqptGlueDosage(BsEqptValveDosageEadit bsEqptValveDosageEadit) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result editTaskAIModel(BsTaskAIModelEdit bsTaskAIModelEdit) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result recommendGlueDosageMethod(Long eqptValveId, Long taskStateId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result goToLC(Long taskId, Long taskStateId, Long userId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result aiModelCustom(Long thisModelId, Long taskStateId, Long userId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }






    @Override
    public Result aiRecommendModelList(Long modelId, String typeMachineSpec, String tOutputCode, String bomCode, Integer pageNum, Integer pageSize) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result findAiRecommendTaskList(String taskCode, Long groupId, Byte taskType, Long selectModelId, Integer pageNum, Integer pageSize) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result aiUpdateModel(Long taskId, Long taskStateId, Long userId, Integer raRequire) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result aiTaskFormulaForFile(Long fileId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result findTaskListByTypeModelId(Long modelId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result checkoutAiModel(Long taskStateId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result systemAdvice(Long taskStateId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getjudgementType(Long taskStateId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getCloseMainProcessTask(String taskCode, Byte type, Long groupId, String typeMachineSpec, Byte stateFlag, Integer pageNum, Integer pageSize) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getNewestTaskStateId(Integer processType, Integer processVersion, Long taskId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getFilterBOMList(FilterBOMDataForPage filterBOMDataForPage) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getjudagementTypeByFileId(Long fileId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result saveMixPowderWeight(ZConsumption zConsumption){

        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getMixPowderWeight(Long taskId,Long taskStateId){
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }


    @Override
    public Result getSpAdvice(StartAdvice startAdvice){
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

}
