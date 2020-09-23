package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TTypeMachineDefaultSetFrontToBack;
import com.wiseq.cn.ykAi.service.servicefbk.TTypeMachineDefaultSetServiceFbk;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/13     jiangbailing      原始版本
 * 文件说明:
 */
@FeignClient(value = "mysqldata-service/tTypeMachineDefaultSet", fallback = TTypeMachineDefaultSetServiceFbk.class)
public interface TTypeMachineDefaultSetService {
    @PostMapping("/set")
    public Result set(@RequestBody TTypeMachineDefaultSetFrontToBack data);


    @GetMapping("/select")
    public Result select(@RequestParam("typeMachineId") Integer typeMachineId);
}
