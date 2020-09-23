package com.wiseq.cn.ykAi.controller;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TGlue;
import com.wiseq.cn.entity.ykAi.TGlueMix;
import com.wiseq.cn.utils.OperatingUtil;
import com.wiseq.cn.ykAi.dao.TGlueDao;
import com.wiseq.cn.ykAi.service.TGlueMixService;
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
public class TGlueMixController {
    @Autowired
    TGlueMixService tGlueMixService;


    /**
     * 原材料库-胶水比例信息新增
     */
    @PostMapping("/tGlueMixInsert")
    public Result tGlueMixinsert(@RequestBody(required=true) List<TGlueMix> tGlueMixList) {
        return tGlueMixService.insert(tGlueMixList);

    }

    /**
     * 原材料库-胶水比例修改
     */
    @PutMapping("/tGlueMixUpdate")
    public Result tGlueMixUpdate(@RequestBody List<TGlueMix> tGlueMixList) {
        return tGlueMixService.update(tGlueMixList);

    }


}
