package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.*;
import com.wiseq.cn.ykAi.service.servicefbk.TColorRegionDtlServiceFbk;
import io.swagger.annotations.ApiOperation;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:色区详情
 */
@FeignClient(value = "mysqldata-service/tColorRegionGroupController", fallback = TColorRegionDtlServiceFbk.class)
public interface TColorRegionDtlService {

    /**
     * 色容差主表删除
     *
     * @return
     */
    @DeleteMapping("/tColorRegionUpdateDel")
    @ApiOperation("色容差主表删除")
    public Result tColorRegionUpdateDel(@RequestBody List<TColorRegion> tColorRegionList);

    /**
     * 新增色区色容差信息信息
     *
     * @return
     */
    @PostMapping("/tColorRegionGroupInsert")
    @ApiOperation("新增色区色容差信息信息")
    public Result tColorRegionGroupInsert(@RequestBody TColorRegionGroup tColorRegionGroup);

    /**
     * 新增色区块信息
     *
     * @return
     */
    @PostMapping("/tColorRegionGroupSKInsert")
    @ApiOperation("新增色区块信息")
    public Result tColorRegionGroupkInsert(@RequestBody TColorRegionGroupSK tColorRegionGroupSK);

    /**
     * 查询色区详细信息
     *
     * @return
     */
    @GetMapping("/tColorRegionDtlFindList")
    public Result tColorRegionDtlFindList(@RequestParam(value = "colorRegionId", required = true) Long colorRegionId,
                                                   @RequestParam(value = "name", required = false) String name,
                                                   @RequestParam(value = "shape", required = false) Byte shape);


    /**
     * 修改色块系列信息
     * @param skInfoDTOS
     * 2020-08-03
     * @return
     */
    @GetMapping("/updateSk")
    public Result updateSk(@RequestBody List<SKInfoDTO> skInfoDTOS);


    /**
     * 修改椭圆
     * @param tyInfoDTO
     * 2020-08-04
     * @return
     */
    @PostMapping("updateTy")
    public Result updateTy(TyInfoDTO tyInfoDTO);

    /**
     * 修改方块/方形
     * @param fkInfoDTO
     * 2020-08-04
     * @return
     */
    @PostMapping("updateFk")
    public Result updateFk(FkInfoDTO fkInfoDTO);
}
