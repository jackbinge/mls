package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TSpcRuleMix;
import com.wiseq.cn.ykAi.service.servicefbk.TSpcRuleServiceFbk;
import io.swagger.annotations.ApiOperation;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient(value = "mysqldata-service/tSpcRuleController",fallback = TSpcRuleServiceFbk.class)
public interface TSpcRuleService {
    @GetMapping("/findSpcRuleMix")
    @ApiOperation(value = "查询")
    Result findSpcRuleMix(@RequestParam("tTypeMachineId")Long tTypeMachineId);


    @PostMapping("/edit")
    @ApiOperation(value = "编辑")
    Result edit(@RequestBody TSpcRuleMix tSpcRuleMix);
}
