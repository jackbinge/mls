package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.OffLineRecommendFrontToBack;
import com.wiseq.cn.entity.ykAi.OnLineRecommendFrontToBack;
import com.wiseq.cn.entity.ykAi.TBOMUpdatePage;
import com.wiseq.cn.entity.ykAi.TBom;
import com.wiseq.cn.ykAi.service.servicefbk.TBomServiceFbk;
import io.swagger.annotations.ApiOperation;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

@FeignClient(value = "mysqldata-service/tBomController", fallback = TBomServiceFbk.class)
public interface TBomService {
    @PostMapping("/bomUpdate")
    @ApiOperation(value = "机种的bom编辑")
    Result bomUpdate(@RequestBody TBOMUpdatePage tbomUpdatePage);


    @GetMapping("/selectAllByTypeMachineId")
    @ApiOperation(value = "通过机钟ID获取其对应的bom列表" )
    Result selectAllByTypeMachineId(@RequestParam(value = "typeMachineId", required = true)Long typeMachineId,
                                    @RequestParam(value = "isTemp", required = false)Boolean isTemp,
                                    @RequestParam(value = "bomCode", required = false)String bomCode,
                                    @RequestParam(value = "bomType",  required = false)Byte bomType,
                                    @RequestParam(value = "bomSource",  required = false)Integer bomSource);
    @GetMapping("/getTGlues")
    @ApiOperation(value = "获取所有的A,B胶列表")
    Result getTGlues();

    @GetMapping("/getTChips")
    @ApiOperation(value = "获取芯片的列表")
    Result getTChips();

    @GetMapping("/getTPhosphors")
    @ApiOperation(value = "获取荧光粉的列表")
    Result getTPhosphors();

    @GetMapping("/getTScaffolds")
    @ApiOperation(value = "获取支架的列表")
    Result getTScaffolds();


    @GetMapping("/selectBomId")
    @ApiOperation(value = "通过BOMID获取其对应的bom详情" )
    Result selectBomId(@RequestParam(value = "bomId")Long bomId);


    @GetMapping("/getSystemRecommedSetUpParameters")
    @ApiOperation(value = "获取系统推荐时的设定参数" )
    Result getSystemRecommedSetUpParameters(@RequestParam(value = "bomId")Long bomId);

    @PostMapping("/offLineRecommendBom")
    @ApiOperation(value = "系统离线推荐BOM--2.0" )
    Result offLineRecommendBom(@RequestBody OffLineRecommendFrontToBack offLineRecommendFrontToBack);

    @PostMapping("/onLineRecommendFrontToBack")
    @ApiOperation(value = "系统在线推荐BOM(生产过程中推荐BOM)--2.0" )
    Result onLineRecommendBom(@RequestBody OnLineRecommendFrontToBack onLineRecommendFrontToBack);


    @PostMapping("/checkBomRepeat")
    @ApiOperation(value = "验证是否已--2.0" )
    Result checkBomRepeat(@RequestBody TBom tBom );

    @GetMapping("/getUseCurrentBomAiModel")
    @ApiOperation(value = "获取使用当前BOM的生产搭配列表--2.0" )
    Result getUseCurrentBomAiModelList(@RequestParam("bomId") Long bomId);

    @PostMapping("/addBom")
    @ApiOperation(value = "新增BOM--2.0" )
    Result addBom(@RequestBody TBom tBom );

    @DeleteMapping("/deleteBom")
    @ApiOperation(value = "删除bom")
    Result deleteBom(@RequestParam("bomId")Long bomId);

    @GetMapping("getBomMinimumWavelengthPhosphor")
    @ApiOperation("获取当前工单对应的配比波长最短的")
    Result getBomMinimumWavelengthPhosphor(@RequestParam("bomId")Long bomId);
}
