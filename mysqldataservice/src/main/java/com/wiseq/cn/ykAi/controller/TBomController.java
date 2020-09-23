package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.*;
import com.wiseq.cn.ykAi.service.TBomService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       jiangbailing      原始版本
 * 文件说明:基础库-机种库BOM库
 */
@RestController
@RequestMapping("/tBomController")
@Api(description = "基础数据库->机种库BOM")
public class TBomController {
    @Autowired
    private TBomService tBomService;

    @PostMapping("/bomUpdate")
    @ApiOperation(value = "机种的bom编辑")
    Result bomUpdate(@RequestBody TBOMUpdatePage tbomUpdatePage){
        return this.tBomService.bomUpdate(tbomUpdatePage);
    }


    @GetMapping("/selectAllByTypeMachineId")
    @ApiOperation(value = "通过机种ID获取其对应的bom列表" )
    Result selectAllByTypeMachineId(@RequestParam(value = "typeMachineId", required = true)Long typeMachineId,
                                    @RequestParam(value = "isTemp", required = false)Boolean isTemp,
                                    @RequestParam(value = "bomCode", required = false)String bomCode,
                                    @RequestParam(value = "bomType",  required = false)Byte bomType,
                                    @RequestParam(value = "bomSource",  required = false)Integer bomSource){
         return ResultUtils.success(this.tBomService.selectAllByTypeMachineId(typeMachineId,isTemp,bomCode,bomType,bomSource));
    }



    @GetMapping("/getTGlues")
    @ApiOperation(value = "获取所有的A,B胶列表")
    Result getTGlues(){
        return ResultUtils.success(this.tBomService.getTGlues());
    }

    @GetMapping("/getTChips")
    @ApiOperation(value = "获取芯片的列表")
    Result getTChips(){
        return ResultUtils.success(this.tBomService.getTChips());
    }

    @GetMapping("/getTPhosphors")
    @ApiOperation(value = "获取荧光粉的列表")
    Result getTPhosphors(){
        return ResultUtils.success(this.tBomService.getTPhosphors());
    }

    @GetMapping("/getTScaffolds")
    @ApiOperation(value = "获取支架的列表")
    Result getTScaffolds(){
        return ResultUtils.success(this.tBomService.getTScaffolds());
    }


    @GetMapping("/selectBomId")
    @ApiOperation(value = "通过BOMID获取其对应的bom详情" )
    Result selectBomId(@RequestParam(value = "bomId")Long bomId){
        return ResultUtils.success(this.tBomService.selectBomByBomId(bomId));
    }

    @GetMapping("/getSystemRecommedSetUpParameters")
    @ApiOperation(value = "获取系统推荐时的设定参数--2.0" )
    Result getSystemRecommedSetUpParameters(@RequestParam(value = "bomId")Long bomId){
        return ResultUtils.success(this.tBomService.getSystemRecommedSetUpParameters(bomId));

    }

    @PostMapping("/offLineRecommendBom")
    @ApiOperation(value = "系统离线推荐BOM--2.0" )
    Result offLineRecommendBom(@RequestBody OffLineRecommendFrontToBack offLineRecommendFrontToBack){
        Result result = this.tBomService.offLineRecommendBom(offLineRecommendFrontToBack);
        return result;
    }

    @PostMapping("/onLineRecommendFrontToBack")
    @ApiOperation(value = "系统在线推荐BOM(生产过程中推荐BOM)--2.0" )
    Result onLineRecommendBom(@RequestBody OnLineRecommendFrontToBack onLineRecommendFrontToBack){
        return this.tBomService.onLineRecommendBom(onLineRecommendFrontToBack);
    }

    @PostMapping("/checkBomRepeat")
    @ApiOperation(value = "验证是否已--2.0" )
    Result checkBomRepeat(@RequestBody TBom tBom ){
        return this.tBomService.checkBomRepeatForEAS(tBom);
    }


    @PostMapping("/addBom")
    @ApiOperation(value = "新增BOM--2.0" )
    Result addBom(@RequestBody TBom tBom ){
        return this.tBomService.addBom(tBom);
    }

    @GetMapping("/getUseCurrentBomAiModel")
    @ApiOperation(value = "获取使用当前BOM的生产搭配列表--2.0" )
    Result getUseCurrentBomAiModelList(@RequestParam("bomId") Long bomId){
        return this.tBomService.getUseCurrentBomAiModelList(bomId);
    }

    @DeleteMapping("/deleteBom")
    @ApiOperation(value = "删除bom")
    Result deleteBom(@RequestParam("bomId")Long bomId){
        return this.tBomService.deleteBom(bomId);
    }

    /**
     * 2020-07-31
      * @param bomId
     * @return
     */
    @GetMapping("getBomMinimumWavelengthPhosphor")
    @ApiOperation("获取当前BOM对应的配比波长最短的")
    Result getBomMinimumWavelengthPhosphor(@RequestParam("bomId")Long bomId){
        return this.tBomService.getBomMinimumWavelengthPhosphor(bomId);
    }
}
