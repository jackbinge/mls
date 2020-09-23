package com.wiseq.cn.ykAi.controller;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TGlue;
import com.wiseq.cn.entity.ykAi.TGroup;
import com.wiseq.cn.utils.OperatingUtil;
import com.wiseq.cn.ykAi.service.TGlueService;
import com.wiseq.cn.ykAi.service.TGroupService;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/11/11      lipeng      原始版本
 * 文件说明:组织结构查询
 */
@RestController
@RequestMapping("/tGroupController")
public class TGroupController {
    @Autowired
    TGroupService tGroupService;

    /**
     * 查询组织结构树
     */
    @GetMapping("/tGroupFindList")
    public Result tGroupFindList(@RequestParam(value = "code", required = false) String code,
                                 @RequestParam(value = "name", required = false) String name) {
        return tGroupService.findGroupTree(code,name);
    }

    /**
     * 新增组织
     */
    @PostMapping("/tGroupInsert")
    public Result tGroupinsert(@RequestBody TGroup tGroup) {
        return tGroupService.insert(tGroup);
    }

    /**
     * 删除组织
     */
    @DeleteMapping("/tGroupDel")
    public Result tGroupDel(@RequestBody TGroup tGroup) {
        return tGroupService.tGroupDel(tGroup);
    }

    /**
     * 生产车间
     * @return
     */
    @GetMapping("/productionShopList")
    @ApiOperation("生产车间")
    Result  productionShopList(){
        return tGroupService.productionShopList();
    }


    @PutMapping("/edit")
    @ApiOperation("编码修改和新增")
    Result updateGroupEasId(@RequestParam("mapEasId") String mapEasId,
                            @RequestParam("id") Long id){
        return tGroupService.updateGroupEasId(mapEasId, id);
    }


    @GetMapping("/productionEASMapList")
    @ApiOperation("获取列表")
    Result getProductionMapEASIdList(@RequestParam(value = "id",required = false) Long id,
                                     @RequestParam(value = "pageNum",required = false) Integer pageNum,
                                     @RequestParam(value = "pageSize",required = false)Integer pageSize){
        return tGroupService.getProductionMapEASIdList(id, pageNum, pageSize);
    }


    @GetMapping("/getNoMapEasIdShopList")
    @ApiOperation("获取没有编码的部门列表")
    public Result getNoMapEasIdShopList() {
        return  tGroupService.getNoMapEasIdShopList();
    }

}
