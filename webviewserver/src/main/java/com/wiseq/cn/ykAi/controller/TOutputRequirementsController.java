package com.wiseq.cn.ykAi.controller;


import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.exception.QuException;
import com.wiseq.cn.entity.ykAi.TOutputRequirementsAll;
import com.wiseq.cn.ykAi.service.TOutputRequirementsService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/TOutputRequirementsController")
@Api(description="基础数据-出货要求")
public class TOutputRequirementsController {
    @Autowired
    private TOutputRequirementsService tOutputRequirementsService;


    @GetMapping("/selectByTypeMachineId")
    @ApiOperation("获取机种对应的出货要求列表")
    Result selectByTypeMachineId(@RequestParam(value = "typeMachineId") Long typeMachineId,
                                                    @RequestParam(value = "outputKind" ,required = false)Byte outputKind,
                                                    @RequestParam(value = "isTemp",required = false)Boolean isTemp,
                                                    @RequestParam(value = "code",required = false)String code){

        return this.tOutputRequirementsService.selectByTypeMachineId(typeMachineId, outputKind, isTemp, code);

    }

    @GetMapping("/findTColorTolerance")
    @ApiOperation("获取机种对应的色容差列表")
    Result findTColorTolerance(@RequestParam(value = "typeMachineId") Long typeMachineId){
        return  this.tOutputRequirementsService.findTColorTolerance(typeMachineId);
    }

    @GetMapping("/findTColorRegionSK")
    @ApiOperation("获取机种对应的色块系列列表")
    Result findTColorRegionSK(@RequestParam(value = "typeMachineId") Long typeMachineId){
       return this.tOutputRequirementsService.findTColorRegionSK(typeMachineId);
    }


    @PostMapping("/updateOutputRequirements")
    @ApiOperation(value = "机种的出货要求编辑")
    Result updateOutputRequirements(@RequestBody TOutputRequirementsAll tOutputRequirementsAll){
        return this.tOutputRequirementsService.updateOutputRequirements(tOutputRequirementsAll);
    }

    @GetMapping("/findAllTColorRegionSKs")
    @ApiOperation(value = "获取该机种的所有色块信息")
    Result findAllTColorRegionSKs(@RequestParam("typeMachineId") Long typeMachineId){
        return this.tOutputRequirementsService.findAllTColorRegionSKs(typeMachineId);
    }


    @GetMapping("/findAllTColorTolerance")
    @ApiOperation(value = "获取该机种的所有色容差信息")
    Result findAllTColorTolerance(@RequestParam("typeMachineId") Long typeMachineId){
        return this.tOutputRequirementsService.findAllTColorTolerance(typeMachineId);
    }

    @GetMapping("/selectTOutputRequirementsByPK")
    @ApiOperation("通过主键获取出货要求")
    public Result selectTOutputRequirementsByPK(@RequestParam("outputId") Long outputId){
        return this.tOutputRequirementsService.selectTOutputRequirementsByPK(outputId);
    }

    /**
     * 拟合中心点
     * @return
     * @throws QuException
     */
    @PostMapping("/centerpointMethod")
    @ApiOperation("拟合中心点")
    public Result centerpointMethod(@RequestParam("jsonStr") String jsonStr){
        return  this.tOutputRequirementsService.centerpointMethod(jsonStr);
    }

    @DeleteMapping("/deleteOutputRequirement")
    @ApiOperation("删除出货要求")
    public Result deleteOutputRequirement(@RequestParam("outputId") Long outputId){
        return this.tOutputRequirementsService.deleteOutputRequiremet(outputId);
    }
}
