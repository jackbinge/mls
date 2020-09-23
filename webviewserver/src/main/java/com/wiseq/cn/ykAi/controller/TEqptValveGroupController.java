package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TEqpt;
import com.wiseq.cn.entity.ykAi.TEqptValve;
import com.wiseq.cn.entity.ykAi.TEqptValveGroup;
import com.wiseq.cn.ykAi.service.TChipService;
import com.wiseq.cn.ykAi.service.TEqptValveGroupService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:点胶设备
 */
@RestController
@RequestMapping("/tEqptValveGroupController")
@Api(description = "点胶设备库新增、启用禁用、逻辑删除")
public class TEqptValveGroupController {
    @Autowired
    TEqptValveGroupService tEqptValveGroupService;

    /**
     * 点胶设备信息新增
     */
    @PostMapping("/tEqptValveGroupInsert")
    @ApiOperation(value = "点胶设备信息新增")
    public Result TEqptValveGroupinsert(@RequestBody TEqptValveGroup tEqptValveGroup) {
        return tEqptValveGroupService.insert(tEqptValveGroup);
    }


    @PutMapping("/tEqptValveGroupUpdateDisabled")
    @ApiOperation("启用禁用")
    public Result tEqptValveGroupUpdateDisabled(@RequestParam("id") Long id,@RequestParam("disable") Boolean disable) {
        return  tEqptValveGroupService.updateDisabled(id,disable);
    }


    @DeleteMapping("/tEqptValveGroupUpdateDel")
    @ApiOperation("逻辑删除")
    public Result tEqptValveGroupUpdateDel(@RequestParam("id") Long id) {
        return tEqptValveGroupService.updateDel(id);
    }

    /**
     * 查询点胶信息的主列表
     */
    @GetMapping("/tEqptFindList")
    @ApiOperation(value = "点胶设备主列表信息查询")
    public Result tEqptFindList(@RequestParam(value = "groupId", required = false) Long groupId,
                                @RequestParam(value = "positon", required = false) String positon,
                                @RequestParam(value = "assetsCode", required = false) String assetsCode,
                                @RequestParam(value = "disabled", required = false) Boolean disabled,
                                @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                @RequestParam(value = "pageSize", required = true) Integer pageSize) {
        return tEqptValveGroupService.findList(groupId, positon, assetsCode, disabled, pageNum, pageSize);

    }
    /**
     * 查询阀体列表信息
     */
    @GetMapping("/tEqptValveFindList")
    @ApiOperation(value = "点胶设备阀体信息查询")
    public Result tEqptValveFindList(@RequestParam(value = "eqptId", required = false) Integer eqptId){
        return tEqptValveGroupService.findTeqptValveList(eqptId);

    }


    /**
     * 点胶设备修改
     */
    @PutMapping("/updateEqpt")
    @ApiOperation("点胶设备修改")
    Result updateEqpt(@RequestBody TEqpt tEqpt){
        return this.tEqptValveGroupService.updateEqpt(tEqpt);
    }
}
