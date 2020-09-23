package com.wiseq.cn.ykAi.service.serviceimpl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.EqptValveStateEnum;
import com.wiseq.cn.commons.enums.FormulaUpdateClassEnum;
import com.wiseq.cn.commons.enums.TaskEnum;
import com.wiseq.cn.commons.exception.QuException;
import com.wiseq.cn.commons.utils.Convert;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.*;
import com.wiseq.cn.ykAi.dao.*;
import com.wiseq.cn.ykAi.service.BsTaskSampleProcessService;
import com.wiseq.cn.ykAi.service.TAiModelService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/6/2     jiangbailing      原始版本
 * 文件说明:
 */
@Service
public class BsTaskSampleProcessServiceImpl implements BsTaskSampleProcessService {
    @Autowired
    private BsTaskStateDao bsTaskStateDao;
    @Autowired
    private BsTaskFormulaDao bsTaskFormulaDao;
    @Autowired
    private BsTaskFormulaDtlDao bsTaskFormulaDtlDao;
    @Autowired
    private BsTaskRecordDao recordDao;
    @Autowired
    private TAiModelService tAiModelService;
    @Autowired
    private BsEqptValveStateDao bsEqptValveStateDao;
    @Autowired
    private BsFormulaUpdateLogDtlDao bsFormulaUpdateLogDtlDao;

    public static final Logger log = LoggerFactory.getLogger(BsTaskSampleProcessServiceImpl.class);
    /**
     * 获取主流程的批量生产工单，发起打样的时候用
     * @param taskCode
     * @return
     */
    @Override
    public Result getMainProcessBatchProductTask(String taskCode) {
        return ResultUtils.success(bsTaskStateDao.getMainProcessBatchTask(taskCode));
    }


    /**
     * 发起打样流程
     * @param taskStateId
     * @return
     */
    @Transactional
    @Override
    public Result initiateSampleProcess(Long taskStateId , Long userId ,String reason) {

        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);
        Long olderTaskStateId = taskStateForDatabase.getId();
        Integer maxProcessVersion = bsTaskStateDao.getSampleMaxProcessVersion(taskStateForDatabase.getTaskId());
        taskStateForDatabase.setProcessType(1);
        taskStateForDatabase.setTaskDfId(TaskEnum.TaskPendingSample.getStateFlag());
        taskStateForDatabase.setProcessCreateTime(Convert.getNow());
        taskStateForDatabase.setProcessInitiator(userId);
        taskStateForDatabase.setProcessVersion(maxProcessVersion + 1);
        taskStateForDatabase.setModelVersion(0);
        taskStateForDatabase.setRatioVersion(0);
        taskStateForDatabase.setInitiateReason(reason);
        bsTaskStateDao.addTaskState(taskStateForDatabase);
        Long newTaskStateId = taskStateForDatabase.getId();
        taskFormulaCopy(olderTaskStateId,newTaskStateId);

        return ResultUtils.success();
    }



    /**
     * 复制配比
     * @param olderTaskStateId
     * @param newTaskStateId
     */
    @Transactional
    public void taskFormulaCopy(Long olderTaskStateId,Long newTaskStateId)throws QuException {
        if(olderTaskStateId == null || newTaskStateId == null){
            new QuException(1,"新的工单状态Id或者旧的工单状态Id为空");
        }
        //获取工单状态和BOM关系表
        List<BsTaskFormulaMix> bsTaskFormulaList = this.bsTaskFormulaDao.getBsTaskFormulaMix(olderTaskStateId);
        if(bsTaskFormulaList == null && bsTaskFormulaList.size() == 0){
            //log.info("taskStateId{}当前状态无配比",olderTaskStateId);
            return;
        }
        List<BsTaskFormulaDtl> bsTaskFormulaDtlList = new ArrayList<>();
        for (BsTaskFormulaMix t:
                bsTaskFormulaList) {
            BsTaskFormula bsTaskFormula = new BsTaskFormula();
            bsTaskFormula.setTaskBomId(t.getTaskBomId());
            bsTaskFormula.setTaskStateId(newTaskStateId);
            this.bsTaskFormulaDao.insertSelective(bsTaskFormula);

            for (BsTaskFormulaDtl t2:
                    t.getBsTaskFormulaDtlList()) {
                t2.setTaskFormulaId(bsTaskFormula.getId());
                //bsTaskFormulaDtlList.add(t2);
                this.bsTaskFormulaDtlDao.insert(t2);
            }

        }
        //this.bsTaskFormulaDtlDao.batchInsert(bsTaskFormulaDtlList);
    }


    /**
     * 获取试样列表的数据
     * @param taskCode
     * @param groupId
     * @param typeMachineSpec
     * @param stateFlag
     * @param pageNum
     * @param pageSize
     * @return
     */
    @Override
    public Result getSampleProcessListInProduction(String taskCode,
                                                   Long groupId,
                                                   String typeMachineSpec,
                                                   Byte stateFlag,
                                                   Integer pageNum,
                                                   Integer pageSize){
        PageHelper.startPage(pageNum,pageSize);
        List<TaskSampleProcess> taskSampleProcessList =  bsTaskStateDao.getSampleProcessInProductTaskList(taskCode,groupId,typeMachineSpec,stateFlag);
        PageInfo pageInfo = new PageInfo(taskSampleProcessList);
        return ResultUtils.success(pageInfo);
    }

    /**
     * 获取打样流程的工单基本信息
     *
     * @param taskStateId
     * @return
     */
    @Override
    public Result getSampleProcessTaskBaseInfo(Long taskStateId){
        Map<String, Object> objectMap = recordDao.getSampleProcessTaskBaseInfo(taskStateId);
        Long outputRequireId = (Long)objectMap.get("outputRequireId");
        Map<String, Object> objectMap1 = recordDao.getOutPutRequirementParameters(outputRequireId);
        objectMap.putAll(objectMap1);
        //是否重新打样或者试样
        Integer num = recordDao.getIsRestSY(taskStateId);
        if(num > 0){
            objectMap.put("isRestSY",true);
        }else{
            objectMap.put("isRestSY",false);
        }
        return ResultUtils.success(objectMap);
    }


    /**
     * 打样通过
     * @param taskStateId
     * @return
     */
    @Override
    @Transactional
    public  Result passSampleProcess(Long taskStateId, Long taskId, Long userId){
        log.info("当前方法的为  {打样通过}   {passSampleProcess}");
        log.info("当前的工单taskId：{}", taskId);
        log.info("当前的工单状态ID-TaskStateId：{}", taskStateId);
        log.info("用户Id{userId}：{}" ,userId);
        Long oldTaskStateId = taskStateId;
        Long newTaskDfId = TaskEnum.TestProcessOK.getStateFlag();
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);
        String fileList = taskStateForDatabase.getFileidList();
        if(!taskStateForDatabase.getTaskDfId().equals(TaskEnum.TaskSamplePreTestOK.getStateFlag())){
            return ResultUtils.error(1,"打样流程状态为:["+TaskEnum.stateFlagOf(taskStateForDatabase.getTaskDfId()).getStateName()+"]不能通过打样");
        }
        //打样流程的状态变更
        bsTaskStateDao.updateTaskStateToNotActive(oldTaskStateId);
        taskStateForDatabase.setTaskDfId(newTaskDfId);
        //taskStateForDatabase.setFileidList("");
        bsTaskStateDao.addTaskState(taskStateForDatabase);
        Long newTaskStateId = taskStateForDatabase.getId();
        taskFormulaCopy(oldTaskStateId,newTaskStateId);//复制配比
        aiTaskFormulaForFile(fileList,userId); //判定是否同步配比到库配比
        //打样流程的阀体复制
        taskEeqptValveCopy(oldTaskStateId,newTaskStateId, EqptValveStateEnum.INProduction.getStateFlag());
        copyTaskEqptGlueDosage(oldTaskStateId,newTaskStateId);
        return ResultUtils.success();
    }

    /**
     * 关闭打样流程
     * @param taskStateId
     * @param taskId
     * @param userId
     * @return
     */
    @Override
    public Result closeSampleProcess(Long taskStateId, Long taskId, Long userId) {
        log.info("当前方法的为  {打样通过}   {passSampleProcess}");
        log.info("当前的工单taskId：{}", taskId);
        log.info("当前的工单状态ID-TaskStateId：{}", taskStateId);
        log.info("用户Id{userId}：{}" ,userId);
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);
        Long oldTaskStateId = taskStateId;
        if(taskStateForDatabase.getTaskDfId().equals(TaskEnum.TaskSamplePreTestOK)){
            return passSampleProcess(taskStateId,taskId,userId);

        }
        Long newTaskDfId = TaskEnum.TestProcessNg.getStateFlag();
        //打样流程的状态变更
        bsTaskStateDao.updateTaskStateToNotActive(oldTaskStateId);
        taskStateForDatabase.setTaskDfId(newTaskDfId);
        taskStateForDatabase.setFileidList("");
        bsTaskStateDao.addTaskState(taskStateForDatabase);
        Long newTaskStateId = taskStateForDatabase.getId();
        taskFormulaCopy(oldTaskStateId,newTaskStateId);//复制配比
        //打样流程的阀体复制
        taskEeqptValveCopy(oldTaskStateId,newTaskStateId, EqptValveStateEnum.INProduction.getStateFlag());
        copyTaskEqptGlueDosage(oldTaskStateId,newTaskStateId);
        return ResultUtils.success();
    }


    @Override
    public Result getCloseAndUnsuccessfulSampleProcessTask(String taskCode,
                                                           Long groupId,
                                                           String typeMachineSpec,
                                                           Byte stateFlag,
                                                           Integer pageNum,
                                                           Integer pageSize){
        PageHelper.startPage(pageNum,pageSize);
        List<TaskSampleProcessClose> taskSampleProcessCloseList = bsTaskStateDao.getCloseAndUnsuccessfulSampleProcessTask(taskCode,groupId,typeMachineSpec,stateFlag);
        PageInfo pageInfo = new PageInfo(taskSampleProcessCloseList);
        return ResultUtils.success(pageInfo);
    }

    @Override
    public Result makeSampleProcessToMainProcess(Long taskStateId, Long taskId, Long userId) {
        //打样流程
        TaskStateForDatabase sampleTaskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);
        //主流程的数据
        TaskStateForDatabase maintaskStateForDatabase = bsTaskStateDao.getTaskMainProcessTaskState(taskId);
        //如果主流程工单关闭则不同步配比
        if( maintaskStateForDatabase.getTaskDfId().equals(TaskEnum.TASKCLOSE.getStateFlag()) ){
            return ResultUtils.error(1,"该工单已经关闭无法同步");
        }
        Long oldMianTaskStateId = maintaskStateForDatabase.getId();
        bsTaskStateDao.updateTaskStateToNotActive(maintaskStateForDatabase.getId());
        maintaskStateForDatabase.setFileidList("");
        //一律改为批量生产中
        maintaskStateForDatabase.setTaskDfId(TaskEnum.TaskBatchProduction.getStateFlag());
        //配方
        maintaskStateForDatabase.setModelId(sampleTaskStateForDatabase.getModelId());
        maintaskStateForDatabase.setModelVersion(maintaskStateForDatabase.getModelVersion() + 1);
        maintaskStateForDatabase.setModelCreator(userId);
        maintaskStateForDatabase.setModelCreateTime(Convert.getNow());
        //配比
        maintaskStateForDatabase.setRatioVersion(0);
        maintaskStateForDatabase.setRatioCreator(userId);
        maintaskStateForDatabase.setRatioSource(sampleTaskStateForDatabase.getRatioSource());
        maintaskStateForDatabase.setRatioCreateTime(Convert.getNow());
        bsTaskStateDao.addTaskState(maintaskStateForDatabase);
        Long newMainTaskStateId = maintaskStateForDatabase.getId();
        taskFormulaCopy(sampleTaskStateForDatabase.getId(),newMainTaskStateId);//复制配比到主流程状态
        //主流程的阀体复制
        taskEeqptValveCopy(oldMianTaskStateId,newMainTaskStateId, EqptValveStateEnum.INProduction.getStateFlag());
        //复制点胶设定参数
        copyTaskEqptGlueDosage(oldMianTaskStateId,newMainTaskStateId);
        return ResultUtils.success();
    }

    @Override
    public Result getSampleRaR9StateForSynchronization(Long taskStateId) {
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);
        Long modelId =  taskStateForDatabase.getModelId();
        BsFormulaTargetParameter bsFormulaTargetParameter = bsFormulaUpdateLogDtlDao.selectTypeMachineTargetParameterByModelId(modelId);
        Double raTarget = bsFormulaTargetParameter.getRaTarget();
        Double r9 = bsFormulaTargetParameter.getR9();
        if(taskStateForDatabase.getRar9Type().equals(0)){
            if(raTarget != null && r9 != null){
                return ResultUtils.success("打样中人工默认Ra/R9为OK！");
            }else if(raTarget != null && r9 == null){
                return ResultUtils.success("打样中人工默认Ra为OK！");
            }else{
                return ResultUtils.success("");
            }

        }
        return ResultUtils.success("");
    }

    /**
     * 上传分光文件后判断是否需要调整配比 需要则调整
     * -- 2020-05-26 改动
     *       -- fileId - > fileList
     * @param fileId
     * @param fileList
     * @return
     */
    @Transactional
    public Result aiTaskFormulaForFile(String fileList,Long userId){
        Long fileId = this.bsTaskStateDao.getJudageSynchronizationFileId(fileList);
        EditTModelFormulaForPage editTModelFormulaForPage  = new EditTModelFormulaForPage();
        Integer num = this.bsTaskStateDao.findFileEuclidean_distance_xAndEuclidean_distance_y(fileId);
        if(num == null){
            return ResultUtils.success();
        }
        if(num > 0){
            List<TModelFormulaForTables> tModelFormulaForTablesList = this.bsTaskStateDao.findTaskFormulaByFileId(fileId);
            Long modelBomId = null;
            if(tModelFormulaForTablesList.size()>0){
                modelBomId =  tModelFormulaForTablesList.get(0).getModelBomId();
            }
            BsFormulaUpdateLog bsFormulaUpdateLog = new BsFormulaUpdateLog();
            bsFormulaUpdateLog.setModelBomId(modelBomId);
            //用户编辑
            bsFormulaUpdateLog.setUpdateType(FormulaUpdateClassEnum.UserEdit.getStateFlag());
            bsFormulaUpdateLog.setCreator(userId);

            editTModelFormulaForPage.setBsFormulaUpdateLog(bsFormulaUpdateLog);
            editTModelFormulaForPage.setTModelFormulaForTables(tModelFormulaForTablesList);

            return tAiModelService.updateModelFormula(editTModelFormulaForPage);
        }
        return ResultUtils.success();
    }


    /**
     * 工单阀体复制加修改阀体状态
     * @param olderTaskStateId
     * @param newTaskStateId
     */
    @Transactional
    public void taskEeqptValveCopy(Long olderTaskStateId,Long newTaskStateId,Long updateToEqptstate){
        if(olderTaskStateId == null || newTaskStateId == null){
            new QuException(1,"新的工单状态Id或者旧的工单状态Id为空");
        }
        if(olderTaskStateId > newTaskStateId){
            new QuException(1,"新旧工单状态异常");
        }
        //获取未关闭的
        List<BsEqptValveState> olderEqptValveList = bsEqptValveStateDao.getTaskStateEqptValve(olderTaskStateId);
        List<BsEqptValveState> newEqptValveList = new ArrayList<>();
        if(olderEqptValveList == null || olderEqptValveList.size() == 0){
            log.info("当前工单状态taskStateId{},无阀体",olderTaskStateId);
            return;
        }
        for (BsEqptValveState t:
                olderEqptValveList) {

            t.setEqptValveDfId(updateToEqptstate);

            t.setTaskStateId(newTaskStateId);
            newEqptValveList.add(t);
        }
        bsEqptValveStateDao.batchInsert(newEqptValveList);
    }

    /**
     * 复制点胶设定参数
     * @param olderTaskStateId
     * @param newTaskStateId
     */
    @Transactional
    public void copyTaskEqptGlueDosage(Long olderTaskStateId,Long newTaskStateId){
        if(olderTaskStateId == null || newTaskStateId == null){
            new QuException(1,"新的工单状态Id或者旧的工单状态Id为空");
        }
        if(olderTaskStateId > newTaskStateId){
            new QuException(1,"新旧工单状态异常");
        }

        List<BsEqptGuleDosage> bsEqptGuleDosageList = this.bsEqptValveStateDao.getTaskEqptValueDosageList(olderTaskStateId);
        if(bsEqptGuleDosageList == null || bsEqptGuleDosageList.size() == 0){
            log.info("当前工单状态taskStateId{},无点胶设定参数",olderTaskStateId);
            return;
        }
        for (BsEqptGuleDosage t:
                bsEqptGuleDosageList) {
            t.setTaskStateId(newTaskStateId);
        }
        bsEqptValveStateDao.batchInsertTaskEqptValueDosage(bsEqptGuleDosageList);
    }



}
