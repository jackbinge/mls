package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.config.FeignMultipartSupportConfig;
import com.wiseq.cn.ykAi.service.servicefbk.QualityServiceFbk;
import io.swagger.annotations.ApiOperation;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@FeignClient(value = "easwo-dataService/qualityController",configuration = FeignMultipartSupportConfig.class,fallback = QualityServiceFbk.class)
public interface QualityService {

    @GetMapping("/getEqptValueList")
    @ApiOperation(value = "获取设备阀体数据")
    public Result getEqptValueList(@RequestParam(value = "billNum")String billNum,@RequestParam(value = "taskStateId") Long taskStateId);


    @PostMapping(value = "/uploadFile",produces = {MediaType.APPLICATION_JSON_UTF8_VALUE},
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @ApiOperation(value = "上传文件")
    public Result uploadFile(@RequestPart("file") MultipartFile file,
                             @RequestParam("userId")String userId,
                             @RequestParam("eqptValueId") String eqptValueId,
                             @RequestParam("billNum")String billNum,
                             @RequestParam("type") Integer type,
                             @RequestParam("taskStateId") Integer taskStateId);

    @GetMapping("/getTestResultInfo")
    @ApiOperation(value = "获取测试信息")
    public Result getTestResultInfo(@RequestParam("taskStateId")Integer taskStateId,
                                    @RequestParam("eqptValueId") String eqptValueId);

    @GetMapping("/getNgRecord")
    @ApiOperation(value = "获取NG记录")
    public Result getNgRecord(@RequestParam("taskStateId")Integer taskStateId,
                              @RequestParam("eqptValueId") String eqptValueId);

    @GetMapping("getAlgorithmData")
    @ApiOperation(value = "获取算法数据")
    public Result getAlgorithmData(@RequestParam("fileId") String fileId,
                                   @RequestParam("eqptValueId") String eqptValueId);

    @GetMapping("/getSpcData")
    @ApiOperation(value = "获取spc数据")
    public Result getSpcData(@RequestParam("taskId") Integer taskId,
                             @RequestParam("eqptValueId") Integer eqptValueId,
                             @RequestParam("testType") Integer testType,
                             @RequestParam("modelId") Integer modelId);
}
