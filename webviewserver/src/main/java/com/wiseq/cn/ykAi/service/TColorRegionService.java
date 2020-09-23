package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.ykAi.service.servicefbk.TChipServiceFbk;
import com.wiseq.cn.ykAi.service.servicefbk.TColorRegionServiceFbk;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:色区
 */
@FeignClient(value = "mysqldata-service/tColorRegionController", fallback = TColorRegionServiceFbk.class)
public interface TColorRegionService {
    @GetMapping("/tColorRegionFindList")
    Result findList(@RequestParam("spec")String spec,
                    @RequestParam("processType")Byte processType,
                    @RequestParam("pageNum")Integer pageNum,
                    @RequestParam("pageSize")Integer pageSize);

    }
