package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TOutputRequireBeforeTestRule;
import com.wiseq.cn.ykAi.service.servicefbk.TBeforeTestRuleServiceFbk;
import io.swagger.annotations.ApiOperation;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@FeignClient(value = "mysqldata-service/TBeforeTestRuleController", fallback = TBeforeTestRuleServiceFbk.class)
public interface TBeforeTestRuleService {
    @GetMapping("/findDtlByOutputRequireId")
    @ApiOperation(value = "测试规则-前测通过出货要求ID")
    Result findDtlByOutputRequireId(@RequestParam("outputRequireId") Long outputRequireId);

    @PutMapping("/edit")
    @ApiOperation(value = "测试规则-前测编辑")
    Result edit(@RequestBody List<TOutputRequireBeforeTestRule> tOutputRequireBeforeTestRules);
}
