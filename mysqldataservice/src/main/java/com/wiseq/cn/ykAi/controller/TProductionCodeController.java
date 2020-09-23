package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TGroup;
import com.wiseq.cn.ykAi.dao.TGroupMapper;
import com.wiseq.cn.ykAi.service.TGroupService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/11/11      lipeng      原始版本
 * 文件说明:生产车间编码页面
 */
@RestController
@RequestMapping("/tProductionCodeController")
public class TProductionCodeController {
    @Autowired
    TGroupService tGroupService;

    /**
     * 查询生产车间编码页面（仅展示第四级有编码的数据，用于页面主列表）
     */
    @GetMapping("/prouctionCodeFindList")
    public Result productionCodeFindList(@RequestParam(value = "groupId", required = false) Long id) {
        return tGroupService.findProductionCodeList(id);
    }

    /**
     * 查询生产车间列表（仅展示第四级无编码的数据，用于新增时的下拉框）
     */
    @GetMapping("/productionCodeFindList")
    public Result productionNoCodeList() {
        return tGroupService.findProductionNoCode();
    }

    /**
     * 新增组织编码
     */
    @PostMapping("/productionCodeInsert")
    public Result productionCodeinsert(@RequestBody TGroup tGroup) {
        return tGroupService.productionCodeinsert(tGroup);
    }

    /**
     * 编辑组织编码
     */
    @PostMapping("/productionCodeUpdate")
    public Result productionCodeUpdate(@RequestBody TGroup tGroup) {
        return tGroupService.productionCodeUpdate(tGroup);
    }



}
