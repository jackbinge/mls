package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TChipWlRank;
import com.wiseq.cn.ykAi.service.servicefbk.TChipWlRankServiceFbk;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-芯片波段
 */
@FeignClient(value = "mysqldata-service/tChipWIRankController", fallback = TChipWlRankServiceFbk.class)
public interface TChipWlRankService {
    //新增考核项
    @PostMapping("/tChipWlRankInsert")
    Result batchInsert(@RequestBody List<TChipWlRank> tChipWlRankList);

    //修改考核项
    @PutMapping("/tChipWlRankUpdate")
    Result batchupdate(@RequestBody List<TChipWlRank> tChipWlRankList);

    //查询主列表
    @GetMapping("/tChipWlRankFindList")
    Result findAll(@RequestParam("chipId") Long chipId);

    //逻辑删除
    @DeleteMapping("/tChipWlRankUpdateStatus")
    Result updateStatus(@RequestBody TChipWlRank tChipWlRank);

}
