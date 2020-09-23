package com.wiseq.cn.ykAi.controller;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TDiffusionPowder;
import com.wiseq.cn.utils.OperatingUtil;
import com.wiseq.cn.ykAi.service.TChipService;
import com.wiseq.cn.ykAi.service.TDiffusionPowderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-扩散粉
 */
@RestController
@RequestMapping("/tDiffusionPowderController")
public class TDiffusionPowderController {
    @Autowired
    TDiffusionPowderService tDiffusionPowderService;

    /**
     * 原材料库-扩散粉信息新增
     */
    @PostMapping("/tDiffusionPowderInsert")
    public Result tChipinsert(@RequestBody TDiffusionPowder tDiffusionPowder) {
        int flag = tDiffusionPowderService.insert(tDiffusionPowder);
        return OperatingUtil.addDeal(flag);
    }

    /**
     * 原材料库-扩散粉修改
     */
    @PutMapping("/tDiffusionPowderUpdate")
    public Result tDiffusionPowderUpdate(@RequestBody TDiffusionPowder tDiffusionPowder) {
        int flag = tDiffusionPowderService.update(tDiffusionPowder);
        return OperatingUtil.updateDeal(flag);
    }

    /**
     * 启用禁用
     */
    @PutMapping("/tDiffusionPowderUpdateDisabled")
    public Result tDiffusionPowderUpdateDisabled(@RequestBody TDiffusionPowder tDiffusionPowder) {
        int flag = tDiffusionPowderService.updateDisabled(tDiffusionPowder);
        return OperatingUtil.updateDeal(flag);
    }

    /**
     * 逻辑删除
     */
    @DeleteMapping("/tDiffusionPowderUpdateDel")
    public Result tDiffusionPowderUpdateDel(@RequestBody TDiffusionPowder tDiffusionPowder) {
        int flag = tDiffusionPowderService.updateDel(tDiffusionPowder);
        return OperatingUtil.updateDeal(flag);
    }

    /**
     * 查询扩散粉信息的主列表
     */
    @GetMapping("/tDiffusionPowderFindList")
    public Result tDiffusionPowderFindList(@RequestParam(value = "diffusionPowderSpec", required = false) String diffusionPowderSpec,
                                @RequestParam(value = "disabled", required = false) Boolean disabled,
                                @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                @RequestParam(value = "pageSize", required = true) Integer pageSize) {
        PageInfo pageInfo = tDiffusionPowderService.findList(diffusionPowderSpec, disabled, pageNum, pageSize);
        return ResultUtils.success(pageInfo);
    }
}
