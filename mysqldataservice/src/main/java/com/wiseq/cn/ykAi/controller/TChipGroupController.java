package com.wiseq.cn.ykAi.controller;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TChipGroup;
import com.wiseq.cn.utils.OperatingUtil;
import com.wiseq.cn.ykAi.service.TChipGroupService;
import com.wiseq.cn.ykAi.service.TChipService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-芯片编辑(修改、新增、删除)
 */
@RestController
@RequestMapping("/tChipGroupController")
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
