package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.ykAi.service.BsTaskSampleProcessService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/6/2     jiangbailing      原始版本
 * 文件说明: 有关打样流程的相关操作 - 只是打样流程独有的和不能和主流程复用的接口
 * -- 2020-06-02 新增接口
 */
@RestController
@RequestMapping("/BsTaskSampleProcessContorller")
@Api(tags = "打样流程管理[新增接口]")
public class BsTaskSampleProcessContorller {
    @Autowired
    private BsTaskSampleProcessService bsTaskSampleProcessService;




    @GetMapping("/initiateSampleProcess")
    @ApiOperation("获取主流程正在量产的工单")
    public Result getMainProcessBatchProductTask(@RequestParam(value = "taskCode" ,required = false ,defaultValue = "") String taskCode){
        return bsTaskSampleProcessService.getMainProcessBatchProductTask(taskCode);
    }


    @PostMapping("/initiateSampleProcess")
    @ApiOperation("发起打样流程")
    public Result initiateSampleProcess(@RequestParam("taskStateId") Long taskStateId ,
                                        @RequestParam("userId") Long userId ,
                                        @RequestParam("reason") String reason){
        return bsTaskSampleProcessService.initiateSampleProcess(taskStateId,userId,reason);
    }

    /**
     *
     * @param taskCode 工单编码
     * @param groupId 生产车间
     * @param typeMachineSpec 机种编码
     * @param stateFlag 工单状态
     * @param pageNum 页码
     * @param pageSize 每页大小
     * @return
     */
    @GetMapping("/getSampleProcessListInProduction")
    @ApiOperation("获取正在生产中的打样流程的工单")
     public  Result getSampleProcessListInProduction(@RequestParam(value = "taskCode" ,required = false ,defaultValue = "") String taskCode,
                                                     @RequestParam(value = "groupId",required = false) Long groupId,
                                                     @RequestParam(value = "typeMachineSpec",required = false) String typeMachineSpec,
                                                     @RequestParam(value = "stateFlag",required = false) Byte stateFlag,
                                                     @RequestParam(value = "pageNum") Integer pageNum,
                                                     @RequestParam(value = "pageSize") Integer pageSize){

        return bsTaskSampleProcessService.getSampleProcessListInProduction(taskCode, groupId, typeMachineSpec, stateFlag, pageNum, pageSize);

     }

    /**
     * 获取打样流程工单的基本信息
     * @param taskStateId
     * @return
     */
    @GetMapping("/getSampleProcessTaskBaseInfo")
    @ApiOperation("获取打样流程工单的基本信息")
    Result getSampleProcessTaskBaseInfo(@RequestParam(value = "taskStateId")Long taskStateId){
        return bsTaskSampleProcessService.getSampleProcessTaskBaseInfo(taskStateId);
    }


    /**
     * 通过打样
     * @param taskStateId
     * @param taskId
     * @param userId
     * @return
     */
    @PostMapping("/passSampleProcess")
    @ApiOperation("通过打样")
    Result passSampleProcess(@RequestParam(value = "taskStateId")Long taskStateId, @RequestParam(value = "taskId")Long taskId,@RequestParam(value = "userId") Long userId){
        return bsTaskSampleProcessService.passSampleProcess(taskStateId, taskId, userId);
    }

    /**
     * 关闭打样流程
     * @param taskStateId
     * @param taskId
     * @param userId
     * @return
     */
    @PostMapping("/closeSampleProcess")
    @ApiOperation("关闭打样流程")
    Result closeSampleProcess(@RequestParam(value = "taskStateId")Long taskStateId, @RequestParam(value = "taskId")Long taskId,@RequestParam(value = "userId") Long userId){
        return bsTaskSampleProcessService.closeSampleProcess(taskStateId, taskId, userId);
    }


    /**
     * 获取已经关闭和失败的打样流程工单
     * @param taskCode
     * @param groupId
     * @param typeMachineSpec
     * @param stateFlag
     * @param pageNum
     * @param pageSize
     * @return
     */
    @GetMapping("/getCloseAndUnsuccessfulSampleProcessTask")
    @ApiOperation("获取已经关闭和失败的打样流程工单")
    Result getCloseAndUnsuccessfulSampleProcessTask(@RequestParam(value = "taskCode" ,required = false ,defaultValue = "") String taskCode,
                                                    @RequestParam(value = "groupId",required = false) Long groupId,
                                                    @RequestParam(value = "typeMachineSpec",required = false) String typeMachineSpec,
                                                    @RequestParam(value = "stateFlag",required = false) Byte stateFlag,
                                                    @RequestParam(value = "pageNum") Integer pageNum,
                                                    @RequestParam(value = "pageSize") Integer pageSize){
        return bsTaskSampleProcessService.getCloseAndUnsuccessfulSampleProcessTask(taskCode, groupId, typeMachineSpec, stateFlag, pageNum, pageSize);
    }


    @PostMapping("/makeSampleProcessToMainProcess")
    @ApiOperation("打样流程同步配比和配方到主流程")
    Result makeSampleProcessToMainProcess(@RequestParam(value = "taskStateId") Long taskStateId, @RequestParam(value = "taskId") Long taskId,@RequestParam(value = "userId") Long userId){

        return bsTaskSampleProcessService.makeSampleProcessToMainProcess(taskStateId, taskId, userId);
    }

    @GetMapping("/getSampleRaR9StateForSynchronization")
    @ApiOperation("/获取打样流程同步时显示的配比RaR9状态")
    Result getSampleRaR9StateForSynchronization(@RequestParam(value = "taskStateId") Long taskStateId){
        return bsTaskSampleProcessService.getSampleRaR9StateForSynchronization(taskStateId);
    }
}
