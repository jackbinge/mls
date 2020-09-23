package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TOutputRequireNbakeRule;
import com.wiseq.cn.ykAi.service.servicefbk.TNoneBakeTestRuleServiceFbk;
import io.swagger.annotations.ApiOperation;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@FeignClient(value = "mysqldata-service/TNoneBakeTestRuleController", fallback = TNoneBakeTestRuleServiceFbk.class)
public interface TNoneBakeTestRuleService {


    @GetMapping("/findTOutputRequireNbakeRuleByOutputRequireId")
    @ApiOperation(value="通过出货要求ID获取非正常烤数据")
    Result findTOutputRequireNbakeRuleByOutputRequireId(@RequestParam("outputRequireId") Long outputRequireId);


    @PutMapping("/edit")
    @ApiOperation(value="编辑非正常烤规则")
    Result edit(@RequestBody List<TOutputRequireNbakeRule> tOutputRequireNbakeRules);
}
