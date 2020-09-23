package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TChipGroup;
import com.wiseq.cn.entity.ykAi.TChipWlRank;
import com.wiseq.cn.ykAi.service.TChipGroupService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-波段
 */
@RestController
@RequestMapping("/tChipGroupController")
@Api(description = "原材料库-波段")
public class TChipGroupController {
    @Autowired
    TChipGroupService tChipGroupService;

    /**
     * 原材料库-芯片信息编辑
     *
     */
    @PostMapping("/tChipGroupUpdate")
    public Result tChipGroupUpdate(@RequestBody TChipGroup tChipGroup) {
        return tChipGroupService.update(tChipGroup);
    }

    /**
     * 原材料库-芯片信息新增
     *
     */
    @PostMapping("/tChipGroupInsert")
    public Result tChipGroupInsert(@RequestBody TChipGroup tChipGroup) {
        return tChipGroupService.insert(tChipGroup);
    }
}
