package com.wiseq.cn.ykAi.controller;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TScaffold;
import com.wiseq.cn.utils.OperatingUtil;
import com.wiseq.cn.ykAi.service.TChipService;
import com.wiseq.cn.ykAi.service.TScaffoldService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-支架
 */
@RestController
@RequestMapping("/tScaffoldController")
public class TScaffoldController {
    @Autowired
    TScaffoldService tScaffoldService;

    /**
     * 原材料库-支架信息新增
     */
    @PostMapping("/tScaffoldInsert")
    public Result tScaffoldinsert(@RequestBody TScaffold tScaffold) {
        int flag = tScaffoldService.insert(tScaffold);
        return OperatingUtil.addDeal(flag);
    }

    /**
     * 原材料库-支架修改
     */
    @PutMapping("/tScaffoldUpdate")
    public Result tScaffoldUpdate(@RequestBody TScaffold tScaffold) {
        int flag = tScaffoldService.update(tScaffold);
        return OperatingUtil.updateDeal(flag);
    }

    /**
     * 启用禁用
     */
    @PutMapping("/tScaffoldUpdateDisabled")
    public Result tScaffoldUpdateDisabled(@RequestBody TScaffold tScaffold) {
        int flag = tScaffoldService.updateDisabled(tScaffold);
        return OperatingUtil.updateDeal(flag);
    }

    /**
     * 逻辑删除
     */
    @DeleteMapping("/tScaffoldUpdateDel")
    public Result tScaffoldUpdateDel(@RequestBody TScaffold tScaffold) {
        int flag = tScaffoldService.updateDel(tScaffold);
        return OperatingUtil.updateDeal(flag);
    }

    /**
     * 查询支架信息的主列表
     */
    @GetMapping("/tScaffoldFindList")
    public Result tScaffoldFindList(@RequestParam(value = "scaffoldSpec", required = false) String scaffoldSpec,
                                @RequestParam(value = "disabled", required = false) Boolean disabled,
                                @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                @RequestParam(value = "pageSize", required = true) Integer pageSize,
                                    @RequestParam(value = "scaffoldType", required = false) Byte scaffoldType) {
        PageInfo pageInfo = tScaffoldService.findList(scaffoldSpec, disabled, pageNum, pageSize,scaffoldType);
        return ResultUtils.success(pageInfo);
    }
}
