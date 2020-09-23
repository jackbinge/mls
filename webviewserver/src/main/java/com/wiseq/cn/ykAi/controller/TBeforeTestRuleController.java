package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TOutputRequireBeforeTestRule;
import com.wiseq.cn.ykAi.service.TBeforeTestRuleService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/TBeforeTestRuleController")
@Api(description="基础数据-测试规则前测规则")
public class TBeforeTestRuleController {
    @Autowired
    private TBeforeTestRuleService tBeforeTestRuleService;

    @GetMapping("/findDtlByOutputRequireId")
    @ApiOperation(value = "测试规则-前测通过出货要求ID")
    Result findDtlByOutputRequireId(@RequestParam("outputRequireId") Long outputRequireId){
        return this.tBeforeTestRuleService.findDtlByOutputRequireId(outputRequireId);
    }

    @PutMapping("/edit")
    @ApiOperation(value = "测试规则-前测编辑")
    Result edit(@RequestBody List<TOutputRequireBeforeTestRule> tOutputRequireBeforeTestRules){
        return this.tBeforeTestRuleService.edit(tOutputRequireBeforeTestRules);
    }

}
