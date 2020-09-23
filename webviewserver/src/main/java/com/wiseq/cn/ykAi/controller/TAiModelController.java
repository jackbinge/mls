package com.wiseq.cn.ykAi.controller;


import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.EditTModelFormulaForPage;
import com.wiseq.cn.entity.ykAi.TAiModel;
import com.wiseq.cn.ykAi.service.TAiModelService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/TAiModelController")
@Api(description="基础数据-配比库页面")
public class TAiModelController {
    @Autowired
    private TAiModelService tAiModelService;


    @GetMapping("/findModelList")
    @ApiOperation(value = "获取配比机种列表-2.0")
    public Result findModelList(@RequestParam(value = "spec",required = false) String spec,
                                @RequestParam(value = "processType",required = false) Byte processType,
                                @RequestParam(value = "pageNum") Integer pageNum,
                                @RequestParam(value = "pageSize")Integer pageSize){
        return tAiModelService.findModelList(spec, processType, pageNum, pageSize);

    }



    @GetMapping("/findChipMixByTypeMachineId")
    @ApiOperation(value = "通过BOMID获取芯片列表")
    public Result findChipMixByTypeMachineId(@RequestParam(value = "id") Long id){
        return tAiModelService.findChipMixByTypeMachineId(id);
    }




    @PostMapping("/insertSelective")
    @ApiOperation(value = "生产搭配新增-2.0")
    public Result addProductCollocation(@RequestBody TAiModel record){
        return tAiModelService.addProductCollocation(record);
    }


    @GetMapping("/findModeLDtlList")
    @ApiOperation(value = "生产搭配列表")
    Result findMoldeList(@RequestParam(value = "typeMachineId")Long typeMachineId,
                         @RequestParam(value = "outputRequireMachineCode",required = false)String outputRequireMachineCode,
                         @RequestParam(value = "bomCode",required = false)String bomCode){
        return tAiModelService.findMoldeList(typeMachineId, outputRequireMachineCode, bomCode);
    }

    @PostMapping("/addModelFormula")
    @ApiOperation(value = "新增配比")
    Result addModelFormula(@RequestBody EditTModelFormulaForPage editTModelFormulaForPage){
        return tAiModelService.addModelFormula(editTModelFormulaForPage);
    }

    @PutMapping("/updateModelFormula")
    @ApiOperation(value = "修改配比")
    Result updateModelFormula(@RequestBody EditTModelFormulaForPage editTModelFormulaForPage){
        return tAiModelService.updateModelFormula(editTModelFormulaForPage);
    }

    @DeleteMapping("/deleteModel")
    @ApiOperation(value = "删除搭配--要改")
    Result deleteModelByPrimaryKey(@RequestParam("id") Long id){
        return tAiModelService.deleteModelByPrimaryKey(id);
    }

    @GetMapping("/findLog")
    @ApiOperation(value = "获取日志--2.0新增字段")
    Result selectFormulaUpdteLog(@RequestParam("modelBomId") Long modelBomId){
        return tAiModelService.selectFormulaUpdteLog(modelBomId);
    }

    @GetMapping("/selectAiModelChip")
    @ApiOperation(value = "生产搭配查看芯片--2.0")
    Result selectAiModelChip(@RequestParam("modelId") Long modelId){
        return tAiModelService.selectAiModelChip(modelId);
    }



    @GetMapping("/selectRatioTargetParameter")
    @ApiOperation(value = "通过配比日志ID获取此配比的目标参数信息--2.0")
    Result selectRatioTargetParameter(Long bsFormulaUpdateLogId){
        return tAiModelService.selectRatioTargetParameter(bsFormulaUpdateLogId);
    }
}
