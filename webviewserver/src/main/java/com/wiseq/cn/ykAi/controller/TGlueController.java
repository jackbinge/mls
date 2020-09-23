package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TGlue;
import com.wiseq.cn.ykAi.service.TGlueService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/31      lipeng      原始版本
 * 文件说明:原材料库-胶水详情
 */
@RestController
@RequestMapping("/tGlueController")
@Api(description = "原材料库-胶水")
public class TGlueController {

    @Autowired
    TGlueService tGlueService;
    /**
     * 启用禁用
     */
    @PutMapping("/tGlueUpdateDisabled")
    @ApiOperation("胶水启用禁用")
    public Result tGlueUpdateDisabled(@RequestBody TGlue tGlue) {
        return tGlueService.updateDisabled(tGlue);

    }

    /**
     * 逻辑删除
     */
    @DeleteMapping("/tGlueUpdateDel")
    @ApiOperation("胶水逻辑删除")
    public Result tGlueUpdateDel(@RequestBody TGlue tGlue) {
        return tGlueService.updateDel(tGlue);

    }
    /**
     * 查询胶水信息的主列表
     */
    @GetMapping("/tABGlueFindList")
    @ApiOperation("胶水主列表")
    public Result tABGlueFindList(@RequestParam(value = "glueSpec", required = false) String glueSpec,
                                  @RequestParam(value = "disabled", required = false) Boolean disabled,
                                  @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                  @RequestParam(value = "pageSize", required = true) Integer pageSize) {
        return  tGlueService.findList(glueSpec, disabled, pageNum, pageSize);

    }

}
