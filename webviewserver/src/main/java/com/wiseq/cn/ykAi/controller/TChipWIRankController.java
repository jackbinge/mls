package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TChipWlRank;
import com.wiseq.cn.ykAi.service.TChipWlRankService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-波段
 */
@RestController
@RequestMapping("/tChipWIRankController")
@Api(description = "原材料库-波段")
public class TChipWIRankController {
    @Autowired
    TChipWlRankService tChipWlRankService;
    /**
     * 查询波段列表
     */
    @GetMapping("/tChipWlRankFindList")
    @ApiOperation(value ="原材料库-芯片波段信息列表查询" )
    public Result tChipWlRankFindList(Long chipId) {
        return tChipWlRankService.findAll(chipId);
    }
}
