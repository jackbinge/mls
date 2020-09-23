package com.wiseq.cn.ykAi.controller;
import	java.awt.Desktop.Action;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TEqpt;
import com.wiseq.cn.entity.ykAi.TEqptValve;
import com.wiseq.cn.entity.ykAi.TEqptValveGroup;
import com.wiseq.cn.utils.OperatingUtil;
import com.wiseq.cn.ykAi.service.TEqptValveGroupService;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/11/5       lipeng      原始版本
 * 文件说明:点胶页面
 */
@RestController
@RequestMapping("/tEqptValveGroupController")
public class TEqptValveGroupController {
    @Autowired
    TEqptValveGroupService tEqptValveGroupService;

    /**
     * 点胶设备信息新增
     */
    @PostMapping("/tEqptValveGroupInsert")
    public Result TEqptValveGroupinsert(@RequestBody TEqptValveGroup tEqptValveGroup) {
        return tEqptValveGroupService.insert(tEqptValveGroup);

    }

    /**
     * 启用禁用
     */
    @PutMapping("/tEqptValveGroupUpdateDisabled")
    public Result tEqptValveGroupUpdateDisabled(@RequestParam("id") Long id,@RequestParam("disable") Boolean disable) {
        int flag = tEqptValveGroupService.updateDisabled(id,disable);
        return OperatingUtil.updateDeal(flag);
    }

    /**
     * 删除
     */
    @DeleteMapping("/tEqptValveGroupUpdateDel")
    public Result tEqptValveGroupUpdateDel(@RequestParam("id") Long id) {
        int flag = tEqptValveGroupService.updateDel(id);
        return OperatingUtil.updateDeal(flag);
    }

    /**
     * 查询点胶信息的主列表
     */
    @GetMapping("/tEqptFindList")
    public Result tEqptFindList(@RequestParam(value = "groupId", required = false) Long groupId,
                                @RequestParam(value = "positon", required = false) String positon,
                                @RequestParam(value = "assetsCode", required = false) String assetsCode,
                                @RequestParam(value = "disabled", required = false) Boolean disabled,
                                @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                @RequestParam(value = "pageSize", required = true) Integer pageSize) {
        PageInfo pageInfo = tEqptValveGroupService.findList(groupId, positon, assetsCode, disabled, pageNum, pageSize);
        return ResultUtils.success(pageInfo);
    }
    /**
     * 查询阀体列表信息
     */
    @GetMapping("/tEqptValveFindList")
    public Result tEqptValveFindList(@RequestParam(value = "eqptId", required = false) Long eqptId){
        List<TEqptValve> tEqptValveList = tEqptValveGroupService.findTeqptValveList(eqptId);
        return ResultUtils.success(tEqptValveList);
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
