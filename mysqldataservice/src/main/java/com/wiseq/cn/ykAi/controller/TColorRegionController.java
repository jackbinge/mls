package com.wiseq.cn.ykAi.controller;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TColorRegionDtl;
import com.wiseq.cn.ykAi.service.TColorRegionDtlService;
import com.wiseq.cn.ykAi.service.TColorRegionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/11/6      lipeng      原始版本
 * 文件说明:色区
 */
@RestController
@RequestMapping("/tColorRegionController")
public class TColorRegionController {
    @Autowired
    TColorRegionService tColorRegionService;

    /**
     * 查询色区信息的主列表
     */
    @GetMapping("/tColorRegionFindList")
    public Result tColorRegionFindList(@RequestParam(value = "spec", required = false) String spec,
                                       @RequestParam(value = "processType", required = false) Byte processType,
                                       @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                       @RequestParam(value = "pageSize", required = true) Integer pageSize) {
        PageInfo pageInfo = tColorRegionService.findList(spec, processType, pageNum, pageSize);
        return ResultUtils.success(pageInfo);
    }
}
