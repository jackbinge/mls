package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.ykAi.service.TChipService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-芯片
 */
@RestController
@RequestMapping("/tChipController")
@Api(description = "原材料库-芯片")
public class TChipController {
    @Autowired
    TChipService tChipService;

    /**
     * 原材料库-芯片信息新增
     */
//    @PostMapping("/tChipInsert")
//    @ApiOperation(value ="原材料库-芯片信息新增" )
//    public Result tChipinsert(@RequestBody TChip tChip) {
//        return tChipService.insert(tChip);
//    }

    /**
     * 原材料库-芯片修改
     */
//    @PutMapping("/tChipUpdate")
//    @ApiOperation(value ="原材料库-芯片信息修改" )
//    public Result tChipUpdate(@RequestBody TChip tChip) {
//        return tChipService.update(tChip);
//    }

    /**
     * 启用禁用
     */
    @PutMapping("/tChipUpdateDisabled")
    @ApiOperation(value ="原材料库-芯片信息启用禁用" )
    public Result tChipUpdateDisabled(@RequestBody TChip tChip) {
        return tChipService.updateDisabled(tChip);
    }

    /**
     * 逻辑删除
     */
    @DeleteMapping("/tChipUpdateDel")
    @ApiOperation(value ="原材料库-逻辑删除" )
    public Result tChipUpdateDel(@RequestBody TChip tChip) {
        return tChipService.updateDel(tChip);
    }

    /**
     * 查询芯片信息的主列表
     */
    @GetMapping("/tChipFindList")
    @ApiOperation(value ="原材料库-芯片信息列表查询" )
    public Result tChipFindList(@RequestParam(value = "chipSpec", required = false) String chipSpec,
                                @RequestParam(value = "disabled", required = false) Boolean disabled,
                                @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                @RequestParam(value = "pageSize", required = true) Integer pageSize) {
        return tChipService.findList(chipSpec, disabled, pageNum, pageSize);
    }
}
