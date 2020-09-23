package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.dataCollection.EqptValue;
import com.wiseq.cn.ykAi.service.QualityService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@Api(value = "数据同步和上传")
@RequestMapping("/qualityController")
public class QualityController {

    @Autowired
    private QualityService qualityService;


    @GetMapping("/getEqptValueList")
    @ApiOperation(value = "获取设备阀体数据")
    public Result getEqptValueList(@RequestParam(value = "billNum")String billNum,@RequestParam(value = "taskStateId") Long taskStateId){

        return qualityService.getEqptValueList(billNum, taskStateId);
    }

    @PostMapping("/uploadFile")
    @ApiOperation(value = "上传文件")
    public Result uploadFile(@RequestPart("file") MultipartFile file,
                             @RequestParam("userId")String userId,
                             @RequestParam("eqptValueId") String eqptValueId,
                             @RequestParam("billNum")String billNum,
                             @RequestParam("type") Integer type,
                             @RequestParam("taskStateId") Integer taskStateId){
        return qualityService.uploadFile(file,userId,eqptValueId,billNum,type,taskStateId);
    }

    /**
     *
     * @param taskId
     * @param taskStateId
     * @param eqptValueId
     * @return
     * -- 2020-06-01 修改
     *      --  参数 taskId -> taskStateId
     */
    @GetMapping("/getTestResultInfo")
    @ApiOperation(value = "获取测试信息[修改参数]")
    public Result getTestResultInfo(@RequestParam("taskStateId")Integer taskStateId,
                                    @RequestParam("eqptValueId") String eqptValueId){
        return qualityService.getTestResultInfo(taskStateId,eqptValueId);
    }

    /**
     *
     * @param taskId
     * @param taskStateId
     * @param eqptValueId
     * @return
     * -- 2020-06-01 修改
     *       --  参数 taskId -> taskStateId
     */
    @GetMapping("/getNgRecord")
    @ApiOperation(value = "获取NG记录[修改参数]")
    public Result getNgRecord(@RequestParam("taskStateId")Integer taskStateId,
                              @RequestParam("eqptValueId") String eqptValueId){
        return qualityService.getNgRecord(taskStateId,eqptValueId);
    }

    @GetMapping("getAlgorithmData")
    @ApiOperation(value = "获取算法数据")
    public Result getAlgorithmData(@RequestParam("fileId") String fileId,
                                   @RequestParam("eqptValueId") String eqptValueId){
        return qualityService.getAlgorithmData(fileId,eqptValueId);
    }

    /**
     *
     * @param taskId
     * @param eqptValueId
     * @param testType
     * @param modelId
     * @return
     *  --- 2020-05-28 此功能暂时已经去掉，暂时不予修改
     *
     */
    @GetMapping("/getSpcData")
    @ApiOperation(value = "获取spc数据[去掉]")
    public Result getSpcData(@RequestParam("taskId") Integer taskId,
                             @RequestParam("eqptValueId") Integer eqptValueId,
                             @RequestParam("testType") Integer testType,
                             @RequestParam("modelId") Integer modelId){
        return qualityService.getSpcData(taskId,eqptValueId,testType,modelId);
    }
}
