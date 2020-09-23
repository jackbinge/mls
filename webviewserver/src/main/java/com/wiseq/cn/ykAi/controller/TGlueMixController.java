package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TGlue;
import com.wiseq.cn.entity.ykAi.TGlueMix;
import com.wiseq.cn.ykAi.service.TGlueMixService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/31      lipeng      原始版本
 * 文件说明:原材料库-胶水比例
 */
@RestController
@RequestMapping("/tGlueMixController")
@Api(description = "原材料库-胶水比例")
public class TGlueMixController {
    @Autowired
    TGlueMixService tGlueMixService;


    /**
     * 原材料库-胶水比例信息新增
     */
    @PostMapping("/tGlueMixInsert")
    @ApiOperation(value ="原原材料库-胶水比例新增" )
    public Result tGlueMixinsert(@RequestBody List<TGlueMix> tGlueMixList) {
        return tGlueMixService.insert(tGlueMixList);
    }

    /**
     * 原材料库-胶水比例修改
     */
    @PutMapping("/tGlueMixUpdate")
    @ApiOperation(value ="原原材料库-胶水比例修改" )
    public Result tGlueMixUpdate(@RequestBody List<TGlueMix> tGlueMixList) {
        return tGlueMixService.update(tGlueMixList);
    }

//    /**
//     * 启用禁用
//     */
//    @PutMapping("/tGlueMixUpdateDisabled")
//    @ApiOperation(value ="原原材料库-胶水比例启用禁用" )
//    public Result tGlueMixUpdateDisabled(@RequestBody TGlue tGlue) {
//        return tGlueMixService.updateDisabled(tGlue);
//    }
//
//    /**
//     * 逻辑删除
//     */
//    @DeleteMapping("/tGlueMixUpdateDel")
//    @ApiOperation(value ="原原材料库-胶水比例逻辑删除" )
//    public Result tGlueMixUpdateDel(@RequestBody TGlue tGlue) {
//        return tGlueMixService.updateDel(tGlue);
//    }
//
//    /**
//     * 查询胶水信息的主列表
//     */
//    @GetMapping("/tABGlueFindList")
//    @ApiOperation(value ="原原材料库-胶水比例例表查询" )
//    public Result tABGlueFindList(@RequestParam(value = "glueSpec", required = false) String glueSpec,
//                                @RequestParam(value = "disabled", required = false) Integer disabled,
//                                @RequestParam(value = "pageNum", required = true) Integer pageNum,
//                                @RequestParam(value = "pageSize", required = true) Integer pageSize) {
//        return tGlueMixService.findList(glueSpec, disabled, pageNum, pageSize);
//    }
}
