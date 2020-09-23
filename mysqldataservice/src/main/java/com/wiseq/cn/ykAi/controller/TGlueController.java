package com.wiseq.cn.ykAi.controller;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TGlue;
import com.wiseq.cn.utils.OperatingUtil;
import com.wiseq.cn.ykAi.service.TGlueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/31      lipeng      原始版本
 * 文件说明:原材料库-胶水详情
 */
@RestController
@RequestMapping("/tGlueController")
public class TGlueController {
    @Autowired
    TGlueService tGlueService;
    /**
     * 启用禁用
     */
    @PutMapping("/tGlueUpdateDisabled")
    public Result tGlueUpdateDisabled(@RequestBody TGlue tGlue) {
        int flag = tGlueService.updateDisabled(tGlue);
        return OperatingUtil.updateDeal(flag);
    }

    /**
     * 逻辑删除
     */
    @DeleteMapping("/tGlueUpdateDel")
    public Result tGlueUpdateDel(@RequestBody TGlue tGlue) {
        int flag = tGlueService.updateDel(tGlue);
        return OperatingUtil.updateDeal(flag);
    }
    /**
     * 查询胶水信息的主列表
     */
    @GetMapping("/tABGlueFindList")
    public Result tABGlueFindList(@RequestParam(value = "glueSpec", required = false) String glueSpec,
                                  @RequestParam(value = "disabled", required = false) Boolean disabled,
                                  @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                  @RequestParam(value = "pageSize", required = true) Integer pageSize) {
        PageInfo pageInfo = tGlueService.findList(glueSpec, disabled, pageNum, pageSize);
        return ResultUtils.success(pageInfo);
    }
}
