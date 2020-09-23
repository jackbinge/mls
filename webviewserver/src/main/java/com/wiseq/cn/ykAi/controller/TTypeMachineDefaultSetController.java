package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TTypeMachineDefaultSetFrontToBack;
import com.wiseq.cn.ykAi.service.TTypeMachineDefaultSetService;
import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/13     jiangbailing      原始版本
 * 文件说明:
 */
@RestController
@RequestMapping("/tTypeMachineDefaultSet")
@Api(tags = "基础数据库->机种库默认材料设置")
public class TTypeMachineDefaultSetController {
    @Autowired
    private TTypeMachineDefaultSetService tTypeMachineDefaultSetService;


    @PostMapping("/set")
    public Result set(@RequestBody TTypeMachineDefaultSetFrontToBack data){
        return tTypeMachineDefaultSetService.set(data);
    }

    @GetMapping("/select")
    public Result select(@RequestParam("typeMachineId") Integer typeMachineId){
        return tTypeMachineDefaultSetService.select(typeMachineId);
    }
}
