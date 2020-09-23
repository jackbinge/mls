package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TEqptValveGroupMix;
import com.wiseq.cn.ykAi.service.TChipService;
import com.wiseq.cn.ykAi.service.TEqptValveGroupMixService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/11/5       lipeng      原始版本
 * 文件说明:点胶设备库编辑
 */
@RestController
@RequestMapping("/tEqptValveGroupMixController")
@Api(description = "点胶设备库编辑")
public class TEqptValveGroupMixController {
    @Autowired
    TEqptValveGroupMixService tEqptValveGroupMixService;

    /**
     * 原材料库-点胶设备信息编辑模块
     */
    @PutMapping("/tEqptValveGroupMixUpdate")
    @ApiOperation(value = "点胶设备库编辑")
    public Result tEqptValveGroupMixUpdate(@RequestBody TEqptValveGroupMix tEqptValveGroupMix) {
        return  tEqptValveGroupMixService.update(tEqptValveGroupMix);
    }
}
