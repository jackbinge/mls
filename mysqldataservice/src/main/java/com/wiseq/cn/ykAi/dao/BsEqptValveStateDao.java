package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.entity.ykAi.*;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/21     jiangbailing      原始版本
 * 文件说明: 工单状态设备表
 */
public interface BsEqptValveStateDao {
    /**
     * 新增工单状态和设备阀体表
     *
     * @param list
     */
    public void batchInsert(List<BsEqptValveState> list);

    /**
     * 获得该状态下的阀体
     *
     * @param taskStateId
     * @return
     */
    public List<BSTaskEqptValve> findTaskStateEqptValve(@Param("taskStateId") Long taskStateId);


    /**
     * @param taskStateId 工单状态表ID
     * @param eqptId      设备ID
     * @return
     * -- 废弃
     */
    public List<EqptValveDosage> findTaskEqptValueList(@Param("taskStateId") Long taskStateId, @Param("eqptId") Long eqptId);


    /**
     * 获取工单对阀体的状态表，只复制未关闭的
     *
     * @param taskStateId
     * @return
     */
    List<BsEqptValveState> getTaskStateEqptValve(@Param("taskStateId") Long taskStateId);

    /**
     * 获取生产中的阀体
     *
     * @param taskStateId
     * @return
     */
    List<BsEqptValveState> getTaskStateProductEqptValve(@Param("taskStateId") Long taskStateId);

    /**
     * 只复制最新的获取该状态下的点胶设定参数
     *
     * @return
     */
    List<BsEqptGuleDosage> getTaskEqptValueDosageList(@Param("taskStateId") Long taskStateId);


    /**
     * 新增阀体点胶设定参数
     *
     * @param list
     * @return
     */
    Integer batchInsertTaskEqptValueDosage(List<BsEqptGuleDosage> list);


    /**
     * 新增阀体工单热表
     *
     * @param bsEqptTaskRuntimeList
     */
    Integer InsertBsEqptTaskRuntime(List<BsEqptTaskRuntime> bsEqptTaskRuntimeList);

    /**
     * 删除阀体工单热表
     *
     * @param eqptValveListDelte
     * @param taskId
     * @return
     */
    Integer deleteBsEqptTaskRuntime(@Param("eqptValveListDelte") List<Long> eqptValveListDelte, @Param("taskId") Long taskId);


    /**
     * 批量修改工单状态对阀体表
     *
     * @param eqptValveList 要修改的阀体的列表
     * @param eqptValveDfId 要修改成的状态
     * @param taskStateId   阀体的状态ID
     * @return
     */
    Integer updateBsTaskStateEqptValve(@Param("eqptValveList") List<Long> eqptValveList,
                                       @Param("eqptValveDfId") Long eqptValveDfId,
                                       @Param("taskStateId") Long taskStateId);

    /**
     * 修改阀体的点胶设定参数
     *
     * @param taskStateId
     * @param bsEqptGuleDosageList
     * @return
     */
    Integer updateBsTaskStateEqptValveDsoge(@Param("taskStateId") Long taskStateId,
                                            @Param("bsEqptGuleDosageList") List<BsEqptGuleDosage> bsEqptGuleDosageList);


    /**
     * 通过阀体获取其机台ID
     *
     * @param eqptValveId
     * @return
     */
    Long getEqptIdByEqptValve(@Param("eqptValveId") Long eqptValveId);


    /**
     * 点胶量推荐
     *
     * @param eqptValveId
     * @param typeMachineId
     * @param fileState
     * @return
     */
    List<Double> eqptValveDosgeRecommend(@Param("eqptValveId") Long eqptValveId,
                                         @Param("typeMachineId") Long typeMachineId,
                                         @Param("fileState") Byte fileState,
                                         @Param("eqptId") Long eqptId);


    /**
     * 获取这个工单的阀体列表
     *
     * @param taskStateId
     * @return
     */
    Integer getTaskStateNGEqptValveListNum(@Param("taskStateId") Long taskStateId);


    /**
     * 新增工单状态表
     * @param taskStateId
     * @param eqptValveIdList
     * @param eqptValveState
     * @return
     */
    Integer insetEqptValveList(@Param("taskStateId") Long taskStateId,
                               @Param("eqptValveIdList") List<Long> eqptValveIdList,
                               @Param("eqptValveState") Long eqptValveState);


}
