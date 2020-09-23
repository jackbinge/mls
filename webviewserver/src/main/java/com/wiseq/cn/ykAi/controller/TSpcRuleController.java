package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TSpcRuleMix;
import com.wiseq.cn.ykAi.service.TSpcRuleService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/10      jiangbailing      原始版本
 * 文件说明:基础库-测试规则
 */
@RestController
@RequestMapping("/tSpcRuleController")
@Api(description = "基础数据库->测试规则SPC")
public class TSpcRuleController {
    @Autowired
    private TSpcRuleService tSpcRuleService;

    @GetMapping("/findSpcRuleMix")
    @ApiOperation(value = "查询")
    Result findSpcRuleMix(@RequestParam("tTypeMachineId")Long tTypeMachineId){
        return this.tSpcRuleService.findSpcRuleMix(tTypeMachineId);
    }


    @PostMapping("/edit")
    @ApiOperation(value = "编辑")
    Result edit(@RequestBody TSpcRuleMix tSpcRuleMix){
        return this.tSpcRuleService.edit(tSpcRuleMix);
    }
}
