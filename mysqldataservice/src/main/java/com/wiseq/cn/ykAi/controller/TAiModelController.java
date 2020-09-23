package com.wiseq.cn.ykAi.controller;
import java.util.List;


import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.FormulaUpdateClassEnum;
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
    @ApiOperation(value = "通过BOMID获取芯片列表-废弃")
    public Result findChipMixByTypeMachineId(@RequestParam(value = "id") Long id){
        return tAiModelService.findChipMixByTypeMachineId(id);
    }




    @PostMapping("/insertSelective")
    @ApiOperation(value = "生产搭配新增-2.0")
    public Result addProductCollocation(@RequestBody TAiModel record){
        return tAiModelService.addProductCollocationReturnId(record);
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
        editTModelFormulaForPage.getBsFormulaUpdateLog().setUpdateType(FormulaUpdateClassEnum.UserEdit.getStateFlag());
        return tAiModelService.addModelFormula(editTModelFormulaForPage);
    }

    @PutMapping("/updateModelFormula")
    @ApiOperation(value = "修改配比")
    Result updateModelFormula(@RequestBody EditTModelFormulaForPage editTModelFormulaForPage){
        editTModelFormulaForPage.getBsFormulaUpdateLog().setUpdateType(FormulaUpdateClassEnum.UserEdit.getStateFlag());
        return tAiModelService.updateModelFormula(editTModelFormulaForPage);
    }

    @DeleteMapping("/deleteModel")
    @ApiOperation(value = "删除搭配")
    Result deleteModelByPrimaryKey(@RequestParam("id") Long id){
        return tAiModelService.deleteModelByPrimaryKey(id);
    }

    @GetMapping("/findLog")
    @ApiOperation(value = "获取日志--2.0加字段")
    Result selectFormulaUpdteLog(@RequestParam("modelBomId") Long modelBomId){
        return tAiModelService.selectFormulaUpdteLog(modelBomId);
    }


    @GetMapping("/selectAiModelChip")
    @ApiOperation(value = "通过生产搭配ID获取其对应的芯片--2.0")
    Result selectAiModelChip(@RequestParam("modelId") Long modelId){
        return ResultUtils.success(tAiModelService.selectAiModelChip(modelId));
    }


    @GetMapping("/selectRatioTargetParameter")
    @ApiOperation(value = "通过配比日志ID获取此配比的目标参数信息--2.0")
    Result selectRatioTargetParameter(Long bsFormulaUpdateLogId){
        return ResultUtils.success(tAiModelService.selectRatioTargetParameter(bsFormulaUpdateLogId));
    }


}
