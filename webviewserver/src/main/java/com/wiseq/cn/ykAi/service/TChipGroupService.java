package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TChipGroup;
import com.wiseq.cn.entity.ykAi.TChipWlRank;
import com.wiseq.cn.ykAi.service.servicefbk.TChipGroupServiceFbk;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-芯片波段
 */
@FeignClient(value = "mysqldata-service/tChipGroupController", fallback = TChipGroupServiceFbk.class)
public interface TChipGroupService {

    //改变芯片波段信息
    @PostMapping("/tChipGroupUpdate")
    Result update(@RequestBody TChipGroup tChipGroup);

    //新增芯片波段信息
    @PostMapping("/tChipGroupInsert")
    Result insert(@RequestBody TChipGroup tChipGroup);
}
