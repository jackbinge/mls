package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.service.servicefbk.TPrivilegeServiceFbk;
import com.wiseq.cn.ykAi.service.servicefbk.TChipServiceFbk;
import io.swagger.annotations.ApiOperation;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient(value = "mysqldata-service/tPrivilegeController", fallback = TPrivilegeServiceFbk.class)
public interface TPrivilegeService {

    @GetMapping("/getTree")
    @ApiOperation("获取菜单的树形结构")
    Result getBaseTree();

    @GetMapping("/getUserTree")
    @ApiOperation("获取菜单的树形结构")
    Result getUserTree(@RequestParam("id") Long id);
}
