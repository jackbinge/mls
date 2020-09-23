package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.ykAi.service.servicefbk.TChipServiceFbk;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-芯片
 */
@FeignClient(value = "mysqldata-service/tChipController", fallback = TChipServiceFbk.class)
public interface TChipService {
    //新增考核项
    @PostMapping("/tChipInsert")
    Result insert(@RequestBody TChip tChip);

    //修改考核项
    @PutMapping("/tChipUpdate")
    Result update(@RequestBody TChip tChip);

    //查询主列表
    @GetMapping("/tChipFindList")
    Result findList(@RequestParam("chipSpec") String chipSpec,
                    @RequestParam("disabled") Boolean disabled,
                    @RequestParam("pageNum") Integer pageNum,
                    @RequestParam("pageSize") Integer pageSize);

    //启用禁用
    @PutMapping("/tChipUpdateDisabled")
    Result updateDisabled(@RequestBody TChip tChip);

    //删除
    @DeleteMapping("/tChipUpdateDel")
    Result updateDel(@RequestBody TChip tChip);

}
