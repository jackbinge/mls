package com.wiseq.cn.ykAi.dao;


import com.wiseq.cn.entity.ykAi.*;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/22     jiangbailing      原始版本
 * 文件说明: g
 */
public interface BsTaskStateDao {
    /**
     * 获取该工单的活跃状态信息
     *
     * @param taskId
     * @param taskStateId
     * @return -- 2020-05-27 修改
     * --只查询主流程
     */
    TaskState getMainTaskStateInfo(@Param("taskStateId") Long taskStateId);


    /**
     * 获取工单列表
     * -- 2020-05-23
     * -- 增加 process_type = 0 只查询主流程
     *
     * @param taskCode
     * @param groupId
     * @param type
     * @param typeMachineSpec
     * @param stateFlag
     * @return
     */
    List<Map<String, Object>> getMainProcessInProductTaskList(@Param("taskCode") String taskCode,
                                                              @Param("type") Byte type,
                                                              @Param("groupId") Long groupId,
                                                              @Param("typeMachineSpec") String typeMachineSpec,
                                                              @Param("stateFlag") Byte stateFlag);

    /**
     * @param modelId
     * @return
     */
    List<BsTaskList> findTaskListByTypeModelId(@Param("modelId") Long modelId);


    /**
     * 新增接口
     *
     * @param bsTaskState
     * @return -- 废弃
     */
    Integer insertSelectiveNoWithFileIdList(BsTaskState bsTaskState);


    /**
     * 新增接口带上之前的文件ID
     *
     * @param bsTaskState
     * @return * -- 废弃
     */
    Integer insetSelectiveWithOlderFileIdList(BsTaskState bsTaskState);


    /**
     * 工单ID
     *
     * @param
     * @return * -- 废弃
     */
    BsTaskState findLastestBsTaskState(@Param("taskId") Long taskId);


    /**
     * 修改工单状态表把状态改为重测
     *
     * @param updateUser
     * @param taskStateId
     * @return * -- 废弃
     */
    Integer updateIsRetestByTaskStateId(@Param("updateUser") String updateUser, @Param("taskStateId") String taskStateId);


    /**
     * 工单关闭
     *
     * @param taskId
     * @return
     */
    Integer closeTask(@Param("taskId") Long taskId, @Param("closeUser") Long closeUser);


    /**
     * 修改工单状态
     *
     * @param bsTaskState
     * @return * -- 废弃
     */
    Integer updateBsTaskStatesById(BsTaskState bsTaskState);

    /**
     * @param taskId
     */
    Integer deleteBsEqptTaskRuntimeByTaskId(@Param("taskId") Long taskId);

    /**
     * 修改阀体状态
     *
     * @param eqptValveDfId
     * @param taskStateId
     * @return * -- 废弃
     */
    Integer updateBsEqptValveStateByTaskId(@Param("eqptValveDfId") Long eqptValveDfId, @Param("taskStateId") Long taskStateId);

    /**
     * 修改阀体状态
     *
     * @param eqptValveDfId
     * @param taskStateId
     * @param eqptValveId
     * @return
     */
    Integer updateOneBsEqptValveStateByTaskId(@Param("eqptValveDfId") Long eqptValveDfId,
                                              @Param("taskStateId") Long taskStateId,
                                              @Param("eqptValveId") Long eqptValveId);

    /**
     * 工单ID获取当前活跃的工单状态
     *
     * @param taskId
     * @return * -- 废弃
     */
    BsTaskState getActiveTaskStateAllInfo(@Param("taskId") Long taskId);

    /**
     * 工单ID获取当前活跃的工单状态 包括其文件ID列表
     *
     * @param taskId
     * @return * -- 废弃
     */
    BsTaskState getActiveTaskStateAllInfoWithFileIdList(@Param("taskId") Long taskId);

    /**
     * 获取可供选择的阀体
     *
     * @param positon
     * @return
     */
    List<TEqpt> getListOfOptionsEqptValve(@Param("positon") Integer positon);


    /**
     * 获取阀体列表
     *
     * @param eqptId
     * @return
     */
    List<TEqptValve> findTeqptValveList(@Param("eqptId") Long eqptId);


    /**
     * 修改工单上传文件的状态
     *
     * @param taskStateId
     * @param fileState
     * @return * -- 废弃
     */
    Integer updateDUploadFile(@Param("taskStateId") Long taskStateId,
                              @Param("fileState") Byte fileState,
                              @Param("isDelete") Boolean isDelete,
                              @Param("fileId") Long fileId,
                              @Param("judgeUser") Long judgeUser);


    /**
     * 获取该工单有分光文件的工单状态ID（因为文件不复制）
     *
     * @param taskId
     * @return * -- 废弃
     */
    Long getThisTaskLastWithFile_TaskStateId(@Param("taskId") Long taskId);


    /**
     * 这个工单的这个阀体未判定的
     *
     * @param fileState
     * @param taskId
     * @param eqptValveId
     * @return * -- 废弃
     */
    Integer updateDUploadFileEqptValve(@Param("fileState") Byte fileState,
                                       @Param("taskId") Long taskId,
                                       @Param("eqptValveId") Long eqptValveId);

    /**
     * 这个工单的这个阀体未判定的文件
     *
     * @param fileState
     * @param taskId
     * @param eqptValveIdList
     * @return * -- 废弃
     */
    Integer updateDUploadFileEqptValveList(@Param("fileState") Byte fileState,
                                           @Param("taskId") Long taskId,
                                           @Param("eqptValveIdList") List<Long> eqptValveIdList);

    /**
     * 修该文件
     *
     * @param eqptValveIdList
     * @return
     */
    Integer updateUploadFileStateNGToOK(@Param("fileIdList") String fileIdList, @Param("eqptValveIdList") List<Long> eqptValveIdList);


    /**
     * 修改阀体状态
     *
     * @param eqptValveDfId
     * @param taskStateId
     * @param eqptValveIdList
     * @return
     */
    Integer updateBsEqptValveListStateNGToProduction(@Param("eqptValveDfId") Long eqptValveDfId,
                                                     @Param("taskStateId") Long taskStateId,
                                                     @Param("eqptValveIdList") List<Long> eqptValveIdList);

    /*推荐工单列表
     * @param taskCode
     * @param groupId
     * @param taskType
     * @return
     */
    List<AiRecommendTaskListPage> findAiRecommendTaskList(@Param("taskCode") String taskCode,
                                                          @Param("groupId") Long groupId,
                                                          @Param("taskType") Byte taskType,
                                                          @Param("modelId") Long modelId);


    /**
     * 获取推荐的模型列表
     *
     * @param modelIdList
     * @param typeMachineSpec
     * @param tOutputCode
     * @param bomCode
     * @return
     */
    List<AiRecommendModelListPage> findModelRecommendList(@Param("modelIdList") List<Long> modelIdList,
                                                          @Param("typeMachineSpec") String typeMachineSpec,
                                                          @Param("tOutputCode") String tOutputCode,
                                                          @Param("bomCode") String bomCode);

    /**
     * 是否重新试样
     *
     * @param taskId
     * @return
     */
    Integer findMainProcessISReset(Long taskId);


    /**
     * 判定
     *
     * @param taskId
     * @return -- 废弃
     */
    Integer isNOJudgeFile(@Param("taskId") Long taskId, @Param("eqptValveId") Long eqptValveId);

    /**
     * 取消文件的NG状态
     *
     * @param fileIdList
     * @return -- 废弃
     */
    Integer updateFileToOKWithList(@Param("fileIdList") String fileIdList);


    /**
     * 获取没有删除并且判定的文件的数量
     *
     * @param fileIdList
     * @return
     */
    Integer findNoJudgeNum(@Param("fileIdList") String fileIdList, @Param("eqptValveId") Long eqptValveId);


    /**
     * 获取文件的配比
     *
     * @param fileId 文件Id
     * @return
     */
    List<TModelFormulaForTables> findTaskFormulaByFileId(@Param("fileId") Long fileId);


    /**
     * 获取分光文件是否满足要求
     *
     * @param fileId
     * @return
     */
    Integer findFileEuclidean_distance_xAndEuclidean_distance_y(@Param("fileId") Long fileId);


    /**
     * 把没有删除并且没有判定的分光文件的状态改为Ok
     *
     * @param fileIdList
     * @return
     */
    Integer updateFileNoJudgeToOKWithList(@Param("fileIdList") String fileIdList,
                                          @Param("eqptValveId") Long eqptValveId,
                                          @Param("judgeUser") Long judgeUser);

    Integer updateFileJudageTypeNOJudge(@Param("fileIdList") String fileIdList,
                                        @Param("eqptValveId") Long eqptValveId,
                                        @Param("judgeType") Integer judgeType);

    Integer updateFileJudageTypeWithEqptValveIdList(@Param("fileIdList") String fileIdList,
                                                    @Param("eqptValveIdList") List<Long> eqptValveIdList,
                                                    @Param("judgeType") Integer judgeType,
                                                    @Param("fileState") Integer fileState);


    /**
     * 删除文件-针对文件重新测试的情况 如果有文件ID则删除单个阀体
     *
     * @param fileId
     * @param fileIdList
     * @param eqptValveId
     * @return
     */
    Integer updateFileNoJudgeToDelete(@Param("fileId") Long fileId,
                                      @Param("fileIdList") String fileIdList,
                                      @Param("eqptValveId") Long eqptValveId,
                                      @Param("judgeUser") Long judgeUser);


    /**
     * 文件修改为NG
     *
     * @param fileIdList
     * @param eqptValveId
     * @return
     */
    Integer updateFileNoJudgeToNg(@Param("fileIdList") String fileIdList,
                                  @Param("eqptValveId") Long eqptValveId,
                                  @Param("judgeUser") Long judgeUser);


    /**
     * 获取最新一次的文件例表
     *
     * @return -- 废弃
     */
    String getLastFileList(Long taskId);


    /**
     * 获取需要判定工单配比是否同步的文件ID
     *
     * @return
     */
    Long getJudageSynchronizationFileId(@Param("fildList") String fildList);


    /**
     * 获取A胶的配比
     *
     * @param glueAId
     * @return
     */
    Double getGlueARatio(@Param("glueAId") Long glueAId);

    /**
     * 获取B胶的配比
     *
     * @param glueBId
     * @return
     */
    Double getGlueBRatio(@Param("glueBId") Long glueBId);


    Double diffusionPowderRaito(@Param("diffusioId") Long diffusioId);


    Double antiStarchMaterialRatio(@Param("antiStarchId") Long antiStarchId);


    /**
     * 获取NG的阀体ID
     *
     * @param taskStateId
     * @return
     */
    List<Long> getNGEqptValveId(@Param("taskStateId") Long taskStateId);

    /**
     * 获取运行的阀体ID
     *
     * @param taskId
     * @return -- 废弃
     */
    List<Long> getRuntimeEqptValveId(@Param("taskId") Long taskId);


    /**
     * 获取工单现在未判定并且未删除的文件
     *
     * @param fileIdList
     * @param eqptValveId
     * @return
     */
    List<Long> selectNoJudegeAndNoDeleteFileIdList(@Param("fileIdList") String fileIdList,
                                                   @Param("eqptValveId") Long eqptValveId);


    /**
     * 记录文件的判定结果
     *
     * @param fileIdList
     * @param resultColorCoordinates
     * @param resultLightness
     * @param resultRa
     * @param resultR9
     * @return
     */
    int batchInsterFileJudgementResult(@Param("list") List<Long> fileIdList,
                                       @Param("resultColorCoordinates") String resultColorCoordinates,
                                       @Param("resultLightness") String resultLightness,
                                       @Param("resultRa") String resultRa,
                                       @Param("resultR9") String resultR9);

    /**
     * 新增文件判断
     * @param fileId
     * @param resultColorCoordinates
     * @param resultLightness
     * @param resultRa
     * @param resultR9
     * @return
     */
    int insetFileJudgementResult(@Param("fileId") Long fileId,
                                 @Param("resultColorCoordinates") String resultColorCoordinates,
                                 @Param("resultLightness") String resultLightness,
                                 @Param("resultRa") String resultRa,
                                 @Param("resultR9") String resultR9);
    /**
     * 获取工单表的所有信息
     *
     * @param taskId
     * @return -- 废弃
     */
    BsTaskTable getBsTaskTableById(@Param("taskId") Long taskId);

    /**
     * 更改工单的的rar9状态
     *
     * @param taskId
     * @param taskStateId
     * @param state       0 为不忽略，1忽略
     * @return -- 废弃
     */
    int updateBsTaskRaR9Require(@Param("taskStateId") Long taskStateId, @Param("state") Integer state);

    /*----------------------------------------------* 2020-05-22 修改 *-----------------------------------------------*/

    /**
     * 通过工单id,流程类型，流程版本 获取当前工单的最新流程状态数据
     *
     * @return
     */
    //String getCurrentTaskStateDataBy_taskId_processType_processVersion(@Param("taskId") Long taskId, @Param("processType") Integer processType, @Param("processVersion") Integer processVersion);


    String getTaskStateFileList(@Param("taskStateId") Long taskStateId);


    /**
     * 获取当前的状态 工单数据
     *
     * @param taskStateId
     * @return
     */
    TaskStateForDatabase getTaskState(@Param("taskStateId") Long taskStateId);



    /**
     * 新增工单状态数据
     *
     * @param taskStateForDatabase
     * @return
     */
    Integer addTaskState(TaskStateForDatabase taskStateForDatabase);

    /**
     * 把工单状态数据改为不活跃状态
     *
     * @return
     */
    Integer updateTaskStateToNotActive(@Param("taskStateId") Long taskStateId);


    /**
     * 修改配比信息
     *
     * @param taskStateId
     * @param ratioVersion
     * @param ratioCreator
     * @param ratioSource
     * @return
     */
    Integer updateTaskRatioInfo(@Param("taskStateId") Long taskStateId, @Param("ratioVersion") Integer ratioVersion, @Param("ratioCreator") Long ratioCreator, @Param("ratioSource") Integer ratioSource);


    /**
     * 获取当前状态在运行的阀体
     *
     * @param taskStateId
     * @return
     */
    List<Long> getTaskStateRunEqptValveList(@Param("taskStateId") Long taskStateId);


    /**
     * 获取当前主流程正在量产的工单
     *
     * @param taskCode
     * @return
     */
    List<Map<String, Object>> getMainProcessBatchTask(@Param("taskCode") String taskCode);


    /**
     * 获取这个工单已经发起的最新的打样流程的版本号
     *
     * @param taskId
     * @return
     */
    Integer getSampleMaxProcessVersion(@Param("taskId") Long taskId);


    /**
     * 获取在制的工单打样流程的数据列表
     *
     * @return
     */
    List<TaskSampleProcess> getSampleProcessInProductTaskList(@Param("taskCode") String taskCode,
                                                              @Param("groupId") Long groupId,
                                                              @Param("typeMachineSpec") String typeMachineSpec,
                                                              @Param("stateFlag") Byte stateFlag);

    /**
     * 获取这个工单主流程的配比信息
     *
     * @return
     */
    TaskStateForDatabase getTaskMainProcessTaskState(@Param("taskId") Long taskId);


    /**
     * 获取已经关闭和失败的打样流程工单
     *
     * @param taskCode
     * @param groupId
     * @param typeMachineSpec
     * @param stateFlag
     * @return
     */
    List<TaskSampleProcessClose> getCloseAndUnsuccessfulSampleProcessTask(@Param("taskCode") String taskCode,
                                                                          @Param("groupId") Long groupId,
                                                                          @Param("typeMachineSpec") String typeMachineSpec,
                                                                          @Param("stateFlag") Byte stateFlag);

    /**
     * 获取主流程已经关闭的工单
     *
     * @param taskCode
     * @param groupId
     * @param typeMachineSpec
     * @param type
     * @return
     */
    List<TaskMainProcessClose> getCloseMainProcessTask(@Param("taskCode") String taskCode,
                                                       @Param("groupId") Long groupId,
                                                       @Param("typeMachineSpec") String typeMachineSpec,
                                                       @Param("type") Byte type);

    /**
     * @param processType
     * @param processVersion
     * @param taskId
     * @return
     */
    Long getNewestTaskStateId(@Param("processType") Integer processType, @Param("processVersion") Integer processVersion, @Param("taskId") Long taskId);

    /**
     * 获取配方对应的机种
     *
     * @param modelId
     * @return
     */
    Long getTypeMachineId(@Param("modelId") Long modelId);

    /**
     * 获取机种对应的BOM
     *
     * @param typeMachineId
     * @return
     */
    List<Long> getBomIdList(@Param("typeMachineId") Long typeMachineId);

    /**
     * 获取bom对应的ChipIdAndNum
     *
     * @param bomId
     * @return
     */
    List<ChipIdAndNum> getBomChipList(@Param("bomId") Long bomId);

    /**
     * @param bomIdList
     * @return
     */
    List<TBom> getBomList(@Param("bomIdList") List<Long> bomIdList);


    Map<String, Integer> getjudagementTypeByFileId(@Param("fileId") Long fileId);

    /**
     * 获得算法模型表数据
     * @param taskStateId
     * @return
     */
    TAlgorithmModel getTAlgorithmModel(@Param("taskStateId") Long taskStateId);
}
