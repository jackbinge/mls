package com.wiseq.cn.ykAi.controller;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TPhosphor;
import com.wiseq.cn.utils.OperatingUtil;
import com.wiseq.cn.ykAi.service.TChipService;
import com.wiseq.cn.ykAi.service.TPhosphorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-荧光粉
 */
@RestController
@RequestMapping("/tPhosphorController")
public class TPhosphorController {
    @Autowired
    TPhosphorService tPhosphorService;

    /**
     * 原材料库-荧光粉信息新增
     */
    @PostMapping("/tPhosphorInsert")
    public Result tPhosphorinsert(@RequestBody TPhosphor tPhosphor) {
        int flag = tPhosphorService.insert(tPhosphor);
        return OperatingUtil.addDeal(flag);
    }

    /**
     * 原材料库-荧光粉修改
     */
    @PutMapping("/tPhosphorUpdate")
    public Result tPhosphorUpdate(@RequestBody TPhosphor tPhosphor) {
        int flag = tPhosphorService.update(tPhosphor);
        return OperatingUtil.updateDeal(flag);
    }

    /**
     * 启用禁用
     */
    @PutMapping("/tPhosphorUpdateDisabled")
    public Result tPhosphorUpdateDisabled(@RequestBody TPhosphor tPhosphor) {
        int flag = tPhosphorService.updateDisabled(tPhosphor);
        return OperatingUtil.updateDeal(flag);
    }

    /**
     * 逻辑删除
     */
    @DeleteMapping("/tPhosphorUpdateDel")
    public Result tPhosphorUpdateDel(@RequestBody TPhosphor tPhosphor) {
        int flag = tPhosphorService.updateDel(tPhosphor);
        return OperatingUtil.updateDeal(flag);
    }

    /**
     * 查询荧光粉信息的主列表
     */
    @GetMapping("/tPhosphorFindList")
    public Result tPhosphorFindList(@RequestParam(value = "phosphorSpec", required = false) String phosphorSpec,
                                @RequestParam(value = "disabled", required = false) Boolean disabled,
                                @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                @RequestParam(value = "pageSize", required = true) Integer pageSize,
                                    @RequestParam(value = "phosphorType",required = false ,defaultValue = "") String phosphorType,
                                    @RequestParam(value = "phosphorTypeId",required = false) Integer phosphorTypeId) {
        PageInfo pageInfo = tPhosphorService.findList(phosphorSpec, disabled, pageNum, pageSize,phosphorType,phosphorTypeId);
        return ResultUtils.success(pageInfo);
    }
}
