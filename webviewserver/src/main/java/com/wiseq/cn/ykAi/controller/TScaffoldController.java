package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TScaffold;
import com.wiseq.cn.ykAi.service.TScaffoldService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-支架
 */
@RestController
@RequestMapping("/tScaffoldController")
@Api(description = "原材料库-支架")
public class TScaffoldController {
    @Autowired
    TScaffoldService tScaffoldService;

    /**
     * 原材料库-支架信息新增
     */
    @PostMapping("/tScaffoldInsert")
    @ApiOperation(value ="原材料库-支架信息新增" )
    public Result tScaffoldinsert(@RequestBody TScaffold tScaffold) {
        return tScaffoldService.insert(tScaffold);
    }

    /**
     * 原材料库-支架修改
     */
    @PutMapping("/tScaffoldUpdate")
    @ApiOperation(value ="原材料库-支架信息修改" )
    public Result tScaffoldUpdate(@RequestBody TScaffold tScaffold) {
        return tScaffoldService.update(tScaffold);
    }

    /**
     * 启用禁用
     */
    @PutMapping("/tScaffoldUpdateDisabled")
    @ApiOperation(value ="原材料库-支架信息启用禁用" )
    public Result tScaffoldUpdateDisabled(@RequestBody TScaffold tScaffold) {
        return tScaffoldService.updateDisabled(tScaffold);
    }

    /**
     * 逻辑删除
     */
    @DeleteMapping("/tScaffoldUpdateDel")
    @ApiOperation(value ="原材料库-支架信息逻辑删除" )
    public Result tScaffoldUpdateDel(@RequestBody TScaffold tScaffold) {
        return tScaffoldService.updateDel(tScaffold);
    }

    /**
     * 查询支架信息的主列表
     */
    @GetMapping("/tScaffoldFindList")
    @ApiOperation(value ="原材料库-支架信息查询主列表" )
    public Result tScaffoldFindList(@RequestParam(value = "scaffoldSpec", required = false) String scaffoldSpec,
                                    @RequestParam(value = "disabled", required = false) Boolean disabled,
                                    @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                    @RequestParam(value = "pageSize", required = true) Integer pageSize,
                                    @RequestParam(value = "scaffoldType", required = false) Byte scaffoldType) {
        return tScaffoldService.findList(scaffoldSpec, disabled, pageNum, pageSize,scaffoldType);
    }
}
