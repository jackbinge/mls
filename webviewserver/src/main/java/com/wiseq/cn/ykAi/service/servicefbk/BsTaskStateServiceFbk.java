package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.ykAi.service.BsTaskStateService;
import org.springframework.stereotype.Service;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/19     jiangbailing      原始版本
 * 文件说明: 工单状态校验
 */
@Service
public class BsTaskStateServiceFbk implements BsTaskStateService {

    @Override
    public Result getActiveTaskState(Long taskId, Long taskStateId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getTaskIsIgnoreRaR9(Long taskStateId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getMainProcessTaskBaseInfo(Long taskStateId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getTaskProductModelRecord(Long taskStateId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getEqptValveRecord(Long taskStateId, Integer modelVersion, Integer ratioVersion, Integer stateType) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getFileTestList(String fileList) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getFileJudgeList(String fileList) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getJudgeRecord(String fileList) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
