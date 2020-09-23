package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TDiffusionPowder;
import com.wiseq.cn.ykAi.service.servicefbk.TDiffusionPowderServiceFbk;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-扩散粉
 */
@FeignClient(value = "mysqldata-service/tDiffusionPowderController", fallback = TDiffusionPowderServiceFbk.class)
public interface TDiffusionPowderService {
    //新增扩散粉
    @PostMapping("/tDiffusionPowderInsert")
    Result insert(@RequestBody TDiffusionPowder tDiffusionPowder);

    //修改扩散粉
    @PutMapping("/tDiffusionPowderUpdate")
    Result update(@RequestBody TDiffusionPowder tDiffusionPowder);

    //查询扩散粉
    @GetMapping("/tDiffusionPowderFindList")
    Result findList(@RequestParam("diffusionPowderSpec") String diffusionPowderSpec,
                    @RequestParam("disabled") Boolean disabled,
                    @RequestParam("pageNum") Integer pageNum,
                    @RequestParam("pageSize") Integer pageSize);

    //启用禁用
    @PutMapping("/tDiffusionPowderUpdateDisabled")
    Result updateDisabled(@RequestBody TDiffusionPowder tDiffusionPowder);

    //删除
    @DeleteMapping("/tDiffusionPowderUpdateDel")
    Result updateDel(@RequestBody TDiffusionPowder tDiffusionPowder);

}
