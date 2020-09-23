package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.entity.dataCollection.FileTestResult;
import com.wiseq.cn.entity.ykAi.BsTaskFormulaDtl;
import com.wiseq.cn.entity.ykAi.EqptValveWithFile;
import com.wiseq.cn.entity.ykAi.FileJudgeRecord;
import com.wiseq.cn.entity.ykAi.FileJudgeResult;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/5/28     jiangbailing      原始版本
 * 文件说明: 工单在制记录/打样记录
 */
public interface BsTaskRecordDao {
    /**
     * 通过出货要求id 获取出货要求信息
     *
     * @param outputRequireId
     * @return
     */
    Map<String, Object> getOutPutRequirementParameters(@Param("outputRequireId") Long outputRequireId);

    /**
     * 获取主流程工单的基本信息
     *
     * @param taskStateId
     * @return
     */
    Map<String, Object> getMainProcessTaskBaseInfo(@Param("taskStateId") Long taskStateId);


    /**
     * 获取配方
     *
     * @param processType
     * @param processVersion
     * @param taskId
     * @return
     */
    List<Map<String, Object>> getFormulaList(@Param("processType") Integer processType, @Param("processVersion") Integer processVersion, @Param("taskId") Long taskId);


    /**
     * 获取配比 对应的 taskFormulaId
     *
     * @param processType
     * @param processVersion
     * @param taskId
     * @param modelVersion
     * @return
     */
    List<Map<String, Object>> getTaskStateRatioInfo(@Param("processType") Integer processType, @Param("processVersion") Integer processVersion, @Param("taskId") Long taskId, @Param("modelVersion") Integer modelVersion);

    /**
     * @param taskFormulaId
     * @return
     */
    List<BsTaskFormulaDtl> getTaskFormulaMaterialRatio(@Param("taskFormulaId") String taskFormulaId);

    /**
     * @param taskFormulaId
     * @return
     */
    List<BsTaskFormulaDtl> getTphosphorLenDen(@Param("taskFormulaId") String taskFormulaId);


    /**
     * 获取分光文件Idlist
     *
     * @param taskId
     * @param modelVersion
     * @param ratioVersion
     * @return
     */
    List<String> getFileList(@Param("taskId") Long taskId,
                             @Param("processType") Integer processType,
                             @Param("processVersion") Integer processVersion,
                             @Param("modelVersion") Integer modelVersion,
                             @Param("ratioVersion") Integer ratioVersion,
                             @Param("stateType") Integer stateType);

    /**
     * 获取阀体和其对应的分光文件
     *
     * @param fileIdList
     * @return
     */
    List<EqptValveWithFile> getEqptValveWithFileList(@Param("fileIdList") Set<Long> fileIdList);

    /**
     * 获取判定的次数
     * @param fileIdList
     * @return
     */
    Integer getJudgeNum(@Param("fileIdList") List<Long> fileIdList);


    /**
     * 获取测试结果
     *
     * @param fileIdList
     * @return
     */
    List<FileTestResult> getFileTestResult(@Param("fileIdList") List<String> fileIdList);


    /**
     * 获取判定结果
     *
     * @param fileIdList
     * @return
     */
    List<FileJudgeResult> getFileJudgeResult(@Param("fileIdList") List<String> fileIdList);


    /**
     * 获取判定记录，每次判定的记录
     *
     * @param fileIdList
     * @return
     */
    List<FileJudgeRecord> getFileJudgeRecord(@Param("fileIdList") List<String> fileIdList);


    /**
     * @param fileIdList
     * @return
     */
    List<Map<String, Object>> getTestResult(@Param("fileIdList") List<String> fileIdList);


    /**
     * 获取打样流程的工单基本信息
     *
     * @param taskStateId
     * @return
     */
    Map<String, Object> getSampleProcessTaskBaseInfo(@Param("taskStateId") Long taskStateId);

    /**
     * 判定其是否重新试样/打样
     *
     * @param taskStateId
     * @return
     */
    Integer getIsRestSY(@Param("taskStateId") Long taskStateId);

    /**
     * 获取状态
     * @param taskStateId
     * @param eqptValueId
     * @return
     */
    String getStateName(@Param("taskStateId") String taskStateId, @Param("eqptValueId") String eqptValueId);

    /**
     * 获取点胶设定参数
     * @param taskStateId
     * @param eqptValueId
     * @return
     */
    Double getDosage(@Param(value = "taskStateId") String taskStateId,
                     @Param(value = "eqptValueId") String eqptValueId);
}
