package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import org.springframework.transaction.annotation.Transactional;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/6/2     jiangbailing      原始版本
 * 文件说明:
 */
public interface BsTaskSampleProcessService {
    Result getMainProcessBatchProductTask(String taskCode);

    Result initiateSampleProcess(Long taskStateId , Long userId , String reason);

    Result getSampleProcessListInProduction(String taskCode,
                                            Long groupId,
                                            String typeMachineSpec,
                                            Byte stateFlag,
                                            Integer pageNum,
                                            Integer pageSize);


    Result getSampleProcessTaskBaseInfo(Long taskStateId);

    @Transactional
    Result passSampleProcess(Long taskStateId, Long taskId, Long userId);

    /**
     * 关闭工单
     * @param taskStateId
     * @param taskId
     * @param userId
     * @return
     */
    Result closeSampleProcess(Long taskStateId, Long taskId,Long userId);

    Result getCloseAndUnsuccessfulSampleProcessTask(String taskCode,
                                                    Long groupId,
                                                    String typeMachineSpec,
                                                    Byte stateFlag,
                                                    Integer pageNum,
                                                    Integer pageSize);

    /**
     * 打样工单同步
     * @param taskStateId
     * @param taskId
     * @param userId
     * @return
     */
    Result makeSampleProcessToMainProcess(Long taskStateId, Long taskId,Long userId);

    /**
     * 获取打样的RAR9
     * @param taskStateId
     * @return
     */
    Result getSampleRaR9StateForSynchronization(Long taskStateId);
}
