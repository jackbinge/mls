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
@RequestMapping("/tColorRegionDtlController")
public class TColorRegionDtlController {

    @Autowired
    TColorRegionDtlService tColorRegionDtlService;

    /**
     * 逻辑删除
     *
     * @return
     */
    @DeleteMapping("/tColorRegionDtlUpdateDel")
    public Result tColorRegionDtlUpdateDel(@RequestBody List<TColorRegionDtl> tColorRegionDtlList) {
        return tColorRegionDtlService.updateDelbunch(tColorRegionDtlList);
    }

    /**
     * 新增色区信息
     *
     * @return
     */
//    @PostMapping("/tColorRegionInsert")
//    public Result tColorRegionInsert(@RequestBody TColorRegionDtl tColorRegionDtl) {
//        return tColorRegionDtlService.tColorRegionInsert(tColorRegionDtl);
//    }

    /**
     * 查询色区详细信息
     *
     * @return
     */
    @GetMapping("/tColorRegionDtlFindList")
    public TColorRegionDtl tColorRegionDtlFindList(@RequestParam(value = "colorRegionId", required = true) Long colorRegionId,
                                                   @RequestParam(value = "name", required = false) String name,
                                                   @RequestParam(value = "shape", required = false) Byte shape) {
        return tColorRegionDtlService.findtColorRegionDtlList(colorRegionId, name, shape);

    }
}
