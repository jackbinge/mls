package com.wiseq.cn.ykAi.controller;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.*;
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
@RequestMapping("/tColorRegionGroupController")
public class TColorRegionGroupController {

    @Autowired
    TColorRegionDtlService tColorRegionDtlService;

    @Autowired
    TColorRegionService tColorRegionService;

    /**
     * 色容差主表删除
     *
     * @return
     */
    @DeleteMapping("/tColorRegionUpdateDel")
    public Result tColorRegionUpdateDel(@RequestBody List<TColorRegion> tColorRegionList) {
        return tColorRegionService.updateDelbunch(tColorRegionList);
    }

    /**
     * 新增色区色容差信息信息
     *
     * @return
     */
    @PostMapping("/tColorRegionGroupInsert")
    public Result tColorRegionGroupInsert(@RequestBody TColorRegionGroup tColorRegionGroup) {
        return tColorRegionDtlService.tColorRegionGroupInsert(tColorRegionGroup);
    }

    /**
     * 新增色区色块信息
     *
     * @return
     */
    @PostMapping("/tColorRegionGroupSKInsert")
    public Result tColorRegionGroupkInsert(@RequestBody TColorRegionGroupSK tColorRegionGroupSK) {
        return tColorRegionDtlService.tColorRegionGroupSKInsert(tColorRegionGroupSK);
    }

    /**
     * 查询色区详细信息
     *
     * @return
     */
    @GetMapping("/tColorRegionDtlFindList")
    public Result tColorRegionDtlFindList(@RequestParam(value = "colorRegionId", required = true) Long colorRegionId,
                                                   @RequestParam(value = "name", required = false) String name,
                                                   @RequestParam(value = "shape", required = false) Byte shape) {
        return ResultUtils.success(tColorRegionDtlService.findtColorRegionDtlList(colorRegionId, name, shape));

    }

    /**
     * 修改色块系列信息
     * @param skInfoDTOS
     * 2020-07-31
     * @return
     */
    @PostMapping("/updateSk")
    public Result updateSk(@RequestBody List<SKInfoDTO> skInfoDTOS){
        return ResultUtils.success(tColorRegionDtlService.updateSk(skInfoDTOS));
    }

    /**
     * 修改椭圆
     * @param tyInfoDTO
     * 2020-08-10
     * 色区库-色容差类型-修改中心点y为0.25，点击保存后y=0.002   bug修复
     * @return
     */
    @PostMapping("updateTy")
    public Result updateTy(@RequestBody TyInfoDTO tyInfoDTO){
        return ResultUtils.success(tColorRegionDtlService.updateTy(tyInfoDTO));

    }

    /**
     * 修改方块/方形
     * @param fkInfoDTO
     * 2020-07-31
     * @return
     */
    @PostMapping("updateFk")
    public Result updateFk(@RequestBody FkInfoDTO fkInfoDTO){
        return ResultUtils.success(tColorRegionDtlService.updateFk(fkInfoDTO));
    }
}
