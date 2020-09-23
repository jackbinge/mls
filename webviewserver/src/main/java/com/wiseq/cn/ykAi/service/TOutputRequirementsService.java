package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.exception.QuException;
import com.wiseq.cn.entity.ykAi.TOutputRequirementsAll;
import com.wiseq.cn.ykAi.service.servicefbk.TOutputRequirementsServiceFbk;
import io.swagger.annotations.ApiOperation;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

@FeignClient(value = "mysqldata-service/TOutputRequirementsController",fallback = TOutputRequirementsServiceFbk.class )
public interface TOutputRequirementsService {

    @GetMapping("/selectByTypeMachineId")
    @ApiOperation("获取机种对应的出货要求列表")
    Result selectByTypeMachineId(@RequestParam(value = "typeMachineId") Long typeMachineId,
                                 @RequestParam(value = "outputKind" ,required = false)Byte outputKind,
                                 @RequestParam(value = "isTemp",required = false)Boolean isTemp,
                                 @RequestParam(value = "code",required = false)String code);

    @GetMapping("/findTColorTolerance")
    @ApiOperation("获取机种对应的色容差列表")
    Result findTColorTolerance(@RequestParam(value = "typeMachineId") Long typeMachineId);

    @GetMapping("/findTColorRegionSK")
    @ApiOperation("获取机种对应的色块系列列表")
    Result findTColorRegionSK(@RequestParam(value = "typeMachineId") Long typeMachineId);

    @PostMapping("/updateOutputRequirements")
    @ApiOperation(value = "机种的出货要求编辑")
    Result updateOutputRequirements(@RequestBody TOutputRequirementsAll tOutputRequirementsAll);

    @GetMapping("/findAllTColorRegionSKs")
    @ApiOperation(value = "获取该机种的所有色块信息")
    Result findAllTColorRegionSKs(@RequestParam("typeMachineId") Long typeMachineId);


    @GetMapping("/findAllTColorTolerance")
    @ApiOperation(value = "获取该机种的所有色容差信息")
    Result findAllTColorTolerance(@RequestParam("typeMachineId") Long typeMachineId);

    @GetMapping("/selectTOutputRequirementsByPK")
    @ApiOperation("通过主键获取出货要求")
    public Result selectTOutputRequirementsByPK(@RequestParam("outputId") Long outputId);

    /**
     * 拟合中心点
     * @return
     * @throws QuException
     */
    @PostMapping("/centerpointMethod")
    @ApiOperation("拟合中心点")
    public Result centerpointMethod(@RequestParam("jsonStr") String jsonStr);

    @DeleteMapping("/deleteOutputRequirement")
    @ApiOperation("删除出货要求")
    Result deleteOutputRequiremet(@RequestParam("outputId") Long outputId);
}
