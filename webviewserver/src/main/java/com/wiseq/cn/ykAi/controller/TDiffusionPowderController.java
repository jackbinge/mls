package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TDiffusionPowder;
import com.wiseq.cn.ykAi.service.TDiffusionPowderService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-扩散粉
 */
@RestController
@RequestMapping("/tDiffusionPowderController")
@Api(description = "原材料库-扩散粉")
public class TDiffusionPowderController {
    @Autowired
    TDiffusionPowderService tDiffusionPowderService;

    /**
     * 原材料库-扩散粉信息新增
     */
    @PostMapping("/tDiffusionPowderInsert")
    @ApiOperation(value ="原材料库-扩散粉信息新增" )
    public Result tChipinsert(@RequestBody TDiffusionPowder tDiffusionPowder) {
        return tDiffusionPowderService.insert(tDiffusionPowder);
    }

    /**
     * 原材料库-扩散粉修改
     */
    @PutMapping("/tDiffusionPowderUpdate")
    @ApiOperation(value ="原材料库-扩散粉信息修改" )
    public Result tDiffusionPowderUpdate(@RequestBody TDiffusionPowder tDiffusionPowder) {
        return tDiffusionPowderService.update(tDiffusionPowder);
    }

    /**
     * 启用禁用
     */
    @PutMapping("/tDiffusionPowderUpdateDisabled")
    @ApiOperation(value ="原材料库-扩散粉信息启用禁用" )
    public Result tDiffusionPowderUpdateDisabled(@RequestBody TDiffusionPowder tDiffusionPowder) {
        return tDiffusionPowderService.updateDisabled(tDiffusionPowder);
    }

    /**
     * 逻辑删除
     */
    @DeleteMapping("/tDiffusionPowderUpdateDel")
    @ApiOperation(value ="原材料库-扩散粉信息逻辑删除" )
    public Result tDiffusionPowderUpdateDel(@RequestBody TDiffusionPowder tDiffusionPowder) {
        return tDiffusionPowderService.updateDel(tDiffusionPowder);
    }

    /**
     * 查询扩散粉信息的主列表
     */
    @GetMapping("/tDiffusionPowderFindList")
    @ApiOperation(value ="原材料库-扩散粉信息列表查询" )
    public Result tDiffusionPowderFindList(@RequestParam(value = "diffusionPowderSpec", required = false) String diffusionPowderSpec,
                                @RequestParam(value = "disabled", required = false) Boolean disabled,
                                @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                @RequestParam(value = "pageSize", required = true) Integer pageSize) {
        return tDiffusionPowderService.findList(diffusionPowderSpec, disabled, pageNum, pageSize);
    }
}
