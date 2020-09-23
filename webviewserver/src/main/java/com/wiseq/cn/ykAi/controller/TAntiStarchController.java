package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TAntiStarch;
import com.wiseq.cn.ykAi.service.TAntiStarchService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-抗沉淀粉
 */
@RestController
@RequestMapping("/tAntiStarchController")
@Api(description = "原材料库-抗沉淀粉")
public class TAntiStarchController {
    @Autowired
    TAntiStarchService tAntiStarchService;

    /**
     * 原材料库-抗沉淀粉信息新增
     */
    @PostMapping("/tAntiStarchInsert")
    @ApiOperation(value ="抗沉淀粉信息新增" )
    public Result tAntiStarchinsert(@RequestBody TAntiStarch tAntiStarch) {
        return tAntiStarchService.insert(tAntiStarch);
    }

    /**
     * 原材料库-抗沉淀粉修改
     */
    @PutMapping("/tAntiStarchUpdate")
    @ApiOperation(value ="抗沉淀粉信息修改" )
    public Result tAntiStarchUpdate(@RequestBody TAntiStarch tAntiStarch) {
        return tAntiStarchService.update(tAntiStarch);
    }

    /**
     * 启用禁用
     */
    @PutMapping("/tAntiStarchUpdateDisabled")
    @ApiOperation(value ="抗沉淀粉启用禁用" )
    public Result tAntiStarchUpdateDisabled(@RequestBody TAntiStarch tAntiStarch) {
        return tAntiStarchService.updateDisabled(tAntiStarch);
    }

    /**
     * 逻辑删除
     */
    @DeleteMapping("/tAntiStarchUpdateDel")
    @ApiOperation(value ="逻辑删除" )
    public Result tAntiStarchUpdateDel(@RequestBody TAntiStarch tAntiStarch) {
        return tAntiStarchService.updateDel(tAntiStarch);
    }

    /**
     * 查询抗沉淀粉信息的主列表
     */
    @GetMapping("/tAntiStarchFindList")
    @ApiOperation(value ="抗沉淀粉信息列表查询" )
    public Result tAntiStarchFindList(@RequestParam(value = "antiStarchSpec", required = false) String antiStarchSpec,
                                      @RequestParam(value = "disabled", required = false) Boolean disabled,
                                      @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                      @RequestParam(value = "pageSize", required = true) Integer pageSize) {
        return tAntiStarchService.findList(antiStarchSpec, disabled, pageNum, pageSize);
    }
}
