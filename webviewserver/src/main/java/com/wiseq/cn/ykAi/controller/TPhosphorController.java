package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TPhosphor;
import com.wiseq.cn.ykAi.service.TPhosphorService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-荧光粉
 */
@RestController
@RequestMapping("/tPhosphorController")
@Api(description = "原材料库-荧光粉")
public class TPhosphorController {
    @Autowired
    TPhosphorService tPhosphorService;

    /**
     * 原材料库-荧光粉信息新增
     */
    @PostMapping("/tPhosphorInsert")
    @ApiOperation(value ="原材料库-荧光粉新增" )
    public Result tPhosphorinsert(@RequestBody TPhosphor tPhosphor) {
        return tPhosphorService.insert(tPhosphor);
    }

    /**
     * 原材料库-荧光粉修改
     */
    @PutMapping("/tPhosphorUpdate")
    @ApiOperation(value ="原材料库-荧光粉修改" )
    public Result tPhosphorUpdate(@RequestBody TPhosphor tPhosphor) {
        return tPhosphorService.update(tPhosphor);
    }

    /**
     * 启用禁用
     */
    @PutMapping("/tPhosphorUpdateDisabled")
    @ApiOperation(value ="原材料库-荧光粉启用禁用" )
    public Result tPhosphorUpdateDisabled(@RequestBody TPhosphor tPhosphor) {
        return tPhosphorService.updateDisabled(tPhosphor);
    }

    /**
     * 逻辑删除
     */
    @DeleteMapping("/tPhosphorUpdateDel")
    @ApiOperation(value ="原材料库-荧光粉逻辑删除" )
    public Result tPhosphorUpdateDel(@RequestBody TPhosphor tPhosphor) {
        return tPhosphorService.updateDel(tPhosphor);
    }

    /**
     * 查询荧光粉信息的主列表
     */
    @GetMapping("/tPhosphorFindList")
    public Result tPhosphorFindList(@RequestParam(value = "phosphorSpec", required = false) String phosphorSpec,
                                    @RequestParam(value = "disabled", required = false) Boolean disabled,
                                    @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                    @RequestParam(value = "pageSize", required = true) Integer pageSize,
                                    @RequestParam(value = "phosphorType",required = false ,defaultValue = "") String phosphorType,
                                    @RequestParam(value = "phosphorTypeId",required = false ) Integer phosphorTypeId) {
       return tPhosphorService.tPhosphorFindList(phosphorSpec, disabled, pageNum, pageSize, phosphorType, phosphorTypeId);
    }
}
