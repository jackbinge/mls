package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.ykAi.service.BsTaskSampleProcessService;
import org.springframework.stereotype.Service;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/6/3     jiangbailing      原始版本
 * 文件说明:
 */
@Service
public class BsTaskSampleProcessServiceFbk implements BsTaskSampleProcessService {
    @Override
    public Result getMainProcessBatchProductTask(String taskCode) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result initiateSampleProcess(Long taskStateId, Long userId, String reason) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }


    @Override
    public Result getSampleProcessListInProduction(String taskCode, Long groupId, String typeMachineSpec, Byte stateFlag, Integer pageNum, Integer pageSize) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getSampleProcessTaskBaseInfo(Long taskStateId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result passSampleProcess(Long taskStateId, Long taskId, Long userId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result closeSampleProcess(Long taskStateId, Long taskId, Long userId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getCloseAndUnsuccessfulSampleProcessTask(String taskCode, Long groupId, String typeMachineSpec, Byte stateFlag, Integer pageNum, Integer pageSize) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result makeSampleProcessToMainProcess(Long taskStateId, Long taskId, Long userId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getSampleRaR9StateForSynchronization(Long taskStateId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
