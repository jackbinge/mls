package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.EditTModelFormulaForPage;
import com.wiseq.cn.entity.ykAi.TAiModel;
import com.wiseq.cn.ykAi.service.servicefbk.TAiModelServiceFbk;
import io.swagger.annotations.ApiOperation;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

@FeignClient(value = "mysqldata-service/TAiModelController", fallback = TAiModelServiceFbk.class)
public interface TAiModelService {

    @GetMapping("/findModelList")
    @ApiOperation(value = "获取配比机种列表")
    public Result findModelList(@RequestParam(value = "spec",required = false) String spec,
                                @RequestParam(value = "processType",required = false) Byte processType,
                                @RequestParam(value = "pageNum") Integer pageNum,
                                @RequestParam(value = "pageSize")Integer pageSize);


    @GetMapping("/findChipMixByTypeMachineId")
    @ApiOperation(value = "通过BOMID获取芯片列表")
    public Result findChipMixByTypeMachineId(@RequestParam(value = "id") Long id);




    @PostMapping("/insertSelective")
    @ApiOperation(value = "生产搭配新增")
    public Result addProductCollocation(@RequestBody TAiModel record);


    @GetMapping("/findModeLDtlList")
    @ApiOperation(value = "生产搭配列表")
    Result findMoldeList(@RequestParam(value = "typeMachineId")Long typeMachineId,
                         @RequestParam(value = "outputRequireMachineCode",required = false)String outputRequireMachineCode,
                         @RequestParam(value = "bomCode",required = false)String bomCode);

    @PostMapping("/addModelFormula")
    @ApiOperation(value = "新增配比")
    Result addModelFormula(@RequestBody EditTModelFormulaForPage editTModelFormulaForPage);

    @PutMapping("/updateModelFormula")
    @ApiOperation(value = "修改配比")
    Result updateModelFormula(@RequestBody EditTModelFormulaForPage editTModelFormulaForPage);

    @DeleteMapping("/deleteModel")
    @ApiOperation(value = "删除搭配")
    Result deleteModelByPrimaryKey(@RequestParam("id") Long id);

    @GetMapping("/findLog")
    @ApiOperation(value = "获取日志")
    Result selectFormulaUpdteLog(@RequestParam("modelBomId") Long modelBomId);

    @GetMapping("/selectAiModelChip")
    @ApiOperation(value = "生产搭配查看芯片2.0")
    Result selectAiModelChip(@RequestParam("modelId") Long modelId);




    @GetMapping("/selectRatioTargetParameter")
    @ApiOperation(value = "通过配比日志ID获取此配比的目标参数信息--2.0")
    Result selectRatioTargetParameter(Long bsFormulaUpdateLogId);
}
