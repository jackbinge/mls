package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.ykAi.service.servicefbk.BsTaskStateServiceFbk;
import io.swagger.annotations.ApiOperation;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/19     jiangbailing      原始版本
 * 文件说明:
 */
@FeignClient(value = "mysqldata-service/BsTaskStateController", fallback = BsTaskStateServiceFbk.class)
public interface BsTaskStateService {

    /**
     * 获取工单最新状态
     * @param taskId
     * @return
     */
    @GetMapping("/getActiveTaskState")
    @ApiOperation("获取工单最新状态")
    Result getActiveTaskState(@RequestParam("taskId") Long taskId,@RequestParam("taskStateId")Long taskStateId);

    @GetMapping("/getTaskIsIgnoreRaR9")
    @ApiOperation("获取工单是否忽略RaR9--2.0 记得建立bom的建立类型")
    Result getTaskIsIgnoreRaR9(@RequestParam("taskStateId") Long taskStateId);

    /**
     * 获取主流程的工单基础信息
     * @param taskStateId
     * @return
     * -- 2020-05-29 新增接口
     */
    @GetMapping("/getMainProcessTaskBaseInfo")
    @ApiOperation("获取主流程的工单基础信息")
    Result getMainProcessTaskBaseInfo(@RequestParam("taskStateId") Long taskStateId);


    /**
     * 获取在制记录/打样记录的生产记录
     * @param taskStateId
     * @return
     *-- 2020-05-30 新增接口
     */
    @GetMapping("/getTaskProductModelRecord")
    @ApiOperation("获取在制记录/打样记录-生产记录")
    Result getTaskProductModelRecord(@RequestParam("taskStateId") Long taskStateId);

    /**
     * 获取阀体和其对应分光文件的生产记录
     * @param taskStateId
     * @param modelVersion
     * @param ratioVersion
     * @param stateType
     * @return
     * -- 2020-05-30 新增接口
     */
    @GetMapping("/getEqptValveRecord")
    @ApiOperation("获取阀体和其对应分光文件的生产记录 stateType 0 试样/打样记录， 1 量产记录")
    Result getEqptValveRecord(@RequestParam("taskStateId") Long taskStateId,
                              @RequestParam("modelVersion")Integer modelVersion,
                              @RequestParam("ratioVersion")Integer ratioVersion,
                              @RequestParam("stateType")Integer stateType);


    /**
     * 获取分光文件的测试结果
     * @param fileList
     * @return
     * -- 2020-06-01 新增接口
     */
    @GetMapping("/getFileTestList")
    @ApiOperation("获取分光文件的测试结果（在制记录-生产记录-品质测试-测试结果）")
    Result getFileTestList(@RequestParam("fileList") String fileList);

    /**
     *获取分光文件的判定结果
     * @param fileList
     * @return
     * -- 2020-06-01 新增接口
     */
    @GetMapping("/getFileJudgeList")
    @ApiOperation("获取分光文件的判定结果（在制记录-生产记录-品质判定-结果判定-查看详情）")
    Result getFileJudgeList(@RequestParam("fileList") String fileList);


    /**
     *
     * @param fileList
     * @return
     * -- 2020-06-01 新增接口
     */
    @GetMapping("/getJudgeRecord")
    @ApiOperation("获取分光文件的判定结果（在制记录-生产记录-品质判定-结果判定）")
    Result getJudgeRecord(@RequestParam("fileList") String fileList);

}
