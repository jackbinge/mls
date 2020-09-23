package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TOutputRequireNbakeRule;
import com.wiseq.cn.ykAi.service.TNoneBakeTestRuleService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/TNoneBakeTestRuleController")
@Api(description="基础数据-测试规则非正常烤规则")
public class TNoneBakeTestRuleController {
    @Autowired
    private TNoneBakeTestRuleService tNoneBakeTestRuleService;

    @GetMapping("/findTOutputRequireNbakeRuleByOutputRequireId")
    @ApiOperation(value="通过出货要求ID获取非正常烤数据")
    Result findTOutputRequireNbakeRuleByOutputRequireId(@RequestParam("outputRequireId") Long outputRequireId){
       return this.tNoneBakeTestRuleService.findTOutputRequireNbakeRuleByOutputRequireId(outputRequireId);
    }


    @PutMapping("/edit")
    @ApiOperation(value="编辑非正常烤规则")
    Result edit(@RequestBody List<TOutputRequireNbakeRule> tOutputRequireNbakeRules){
        return this.tNoneBakeTestRuleService.edit(tOutputRequireNbakeRules);
    }


    
}
