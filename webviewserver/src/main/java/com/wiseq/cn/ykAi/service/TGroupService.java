package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TGroup;
import com.wiseq.cn.ykAi.service.servicefbk.TChipServiceFbk;
import com.wiseq.cn.ykAi.service.servicefbk.TGroupServiceFbk;
import io.swagger.annotations.ApiOperation;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:组织
 */
@FeignClient(value = "mysqldata-service/tGroupController", fallback = TGroupServiceFbk.class)
public interface TGroupService {


    /**
     * 查询组织结构树
     */
    @GetMapping("/tGroupFindList")
    public Result tGroupFindList(@RequestParam(value = "code", required = false) String code,
                                 @RequestParam(value = "name", required = false) String name);

    /**
     * 新增组织
     */
    @PostMapping("/tGroupInsert")
    public Result tGroupinsert(@RequestBody TGroup tGroup);

    /**
     * 删除组织
     */
    @DeleteMapping("/tGroupDel")
    public Result tGroupDel(@RequestBody TGroup tGroup);


    /**
     * 生产车间
     * @return
     */
    @GetMapping("/productionShopList")
    Result  productionShopList();



    @PutMapping("/edit")
    @ApiOperation("编码修改和新增")
    Result updateGroupEasId(@RequestParam("mapEasId") String mapEasId,
                            @RequestParam("id") Long id);


    @GetMapping("/productionEASMapList")
    @ApiOperation("获取列表")
    Result getProductionMapEASIdList(@RequestParam(value = "id",required = false) Long id,
                                     @RequestParam(value = "pageNum",required = false) Integer pageNum,
                                     @RequestParam(value = "pageSize",required = false)Integer pageSize);


    @GetMapping("/getNoMapEasIdShopList")
    @ApiOperation("获取没有编码的部门列表")
    public Result getNoMapEasIdShopList();

}
