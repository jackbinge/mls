package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TColorRegion;
import com.wiseq.cn.entity.ykAi.TColorRegionDtl;
import com.wiseq.cn.ykAi.service.TColorRegionDtlService;
import com.wiseq.cn.ykAi.service.TColorRegionService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:色区
 */
@RestController
@RequestMapping("/tColorRegionDtlController")
@Api(description = "色区详情查询")
public class TColorRegionDtlController {

    @Autowired
    TColorRegionDtlService tColorRegionDtlService;

    /**
     * 逻辑删除
     *
     * @return
     */
//    @DeleteMapping("/tColorRegionUpdateDel")
//    @ApiOperation(value = "色区逻辑删除")
//    public Result tColorRegionUpdateDel(@RequestBody List<TColorRegion> tColorRegionList) {
//        return tColorRegionDtlService.updateDelbunch(tColorRegionList);
//    }

    /**
     * 新增色区信息
     *
     * @return
     */
//    @PostMapping("/tColorRegionDtlInsert")
//    @ApiOperation(value = "色区新增")
//    public Result tColorRegionDtlInsert(@RequestBody TColorRegionDtl tColorRegionDtl) {
//        return tColorRegionDtlService.tColorRegionInsert(tColorRegionDtl);
//    }

    /**
     * 查询色区详细信息
     *
     * @return
     */
    @GetMapping("/tColorRegionDtlFindList")
    @ApiOperation(value = "色区详情查询")
    public Result tColorRegionDtlFindList(@RequestParam(value = "colorRegionId", required = true) Long colorRegionId,
                                          @RequestParam(value = "name", required = false) String name,
                                          @RequestParam(value = "shape", required = false) Byte shape) {
        return tColorRegionDtlService.tColorRegionDtlFindList(colorRegionId, name, shape);

    }
}
