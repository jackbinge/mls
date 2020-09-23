package com.wiseq.cn.ykAi.controller;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TAntiStarch;
import com.wiseq.cn.utils.OperatingUtil;
import com.wiseq.cn.ykAi.service.TAntiStarchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-抗沉淀粉
 */
@RestController
@RequestMapping("/tAntiStarchController")
public class TAntiStarchController {
    @Autowired
    TAntiStarchService tAntiStarchService;

    /**
     * 原材料库-抗沉淀粉信息新增
     */
    @PostMapping("/tAntiStarchInsert")
    public Result tAntiStarchinsert(@RequestBody TAntiStarch tAntiStarch) {
        int flag = tAntiStarchService.insert(tAntiStarch);
        return OperatingUtil.addDeal(flag);
    }

    /**
     * 原材料库-抗沉淀粉修改
     */
    @PutMapping("/tAntiStarchUpdate")
    public Result tAntiStarchUpdate(@RequestBody TAntiStarch tAntiStarch) {
        int flag = tAntiStarchService.update(tAntiStarch);
        return OperatingUtil.updateDeal(flag);
    }

    /**
     * 启用禁用
     */
    @PutMapping("/tAntiStarchUpdateDisabled")
    public Result tAntiStarchUpdateDisabled(@RequestBody TAntiStarch tAntiStarch) {
        int flag = tAntiStarchService.updateDisabled(tAntiStarch);
        return OperatingUtil.updateDeal(flag);
    }

    /**
     * 逻辑删除
     */
    @DeleteMapping("/tAntiStarchUpdateDel")
    public Result tAntiStarchUpdateDel(@RequestBody TAntiStarch tAntiStarch) {
        int flag = tAntiStarchService.updateDel(tAntiStarch);
        return OperatingUtil.updateDeal(flag);
    }

    /**
     * 查询抗沉淀粉信息的主列表
     */
    @GetMapping("/tAntiStarchFindList")
    public Result tAntiStarchFindList(@RequestParam(value = "antiStarchSpec", required = false) String antiStarchSpec,
                                      @RequestParam(value = "disabled", required = false) Boolean disabled,
                                      @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                      @RequestParam(value = "pageSize", required = true) Integer pageSize) {
        PageInfo pageInfo = tAntiStarchService.findList(antiStarchSpec, disabled, pageNum, pageSize);
        return ResultUtils.success(pageInfo);
    }
}
