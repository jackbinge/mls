package com.wiseq.cn.ykAi.controller;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TChipWlRank;
import com.wiseq.cn.utils.OperatingUtil;
import com.wiseq.cn.ykAi.service.TChipService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-芯片
 */
@RestController
@RequestMapping("/tChipController")
public class TChipController {
    @Autowired
    TChipService tChipService;

    /**
     * 启用禁用
     */
    @PutMapping("/tChipUpdateDisabled")
    public Result tChipUpdateDisabled(@RequestBody TChip tChip) {
        int flag = tChipService.updateDisabled(tChip);
        return OperatingUtil.updateDeal(flag);
    }



    /**
     * 逻辑删除
     */
    @DeleteMapping("/tChipUpdateDel")
    public Result tChipUpdateDel(@RequestBody TChip tChip) {
        int flag = tChipService.updateDel(tChip);
        return OperatingUtil.updateDeal(flag);
    }

    /**
     * 查询芯片信息的主列表
     */
    @GetMapping("/tChipFindList")
    public Result tChipFindList(@RequestParam(value = "chipSpec", required = false) String chipSpec,
                                @RequestParam(value = "disabled", required = false) Boolean disabled,
                                @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                @RequestParam(value = "pageSize", required = true) Integer pageSize) {
        PageInfo pageInfo = tChipService.findList(chipSpec, disabled, pageNum, pageSize);
        return ResultUtils.success(pageInfo);
    }

}
