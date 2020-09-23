package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/19     jiangbailing      原始版本
 * 文件说明:
 */
public interface BsTaskStateService {
    Result getActiveTaskState(Long taskId,Long taskStateId);

    Result getTaskIsIgnoreRaR9(Long taskStateId);

    Result getMainProcessTaskBaseInfo(Long taskStateId);

    Result getTaskProductFormulaRecord(Long taskStateId);

    Result getEqptValveRecord(Long taskStateId, Integer modelVersion, Integer ratioVersion, Integer stateType);

    Result getFileTestList(String fileList);

    Result getFileJudgeList(String fileList);

    Result getJudgeRecord(String fileList);


}
