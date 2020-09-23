package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.MaterialTypeMap;
import com.wiseq.cn.entity.ykAi.MaterialTypeMapMix;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.ykAi.service.servicefbk.MaterialTypeMapServiceFbk;
import com.wiseq.cn.ykAi.service.servicefbk.TChipServiceFbk;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:材料类型
 */
@FeignClient(value = "mysqldata-service/materialTypeMapController", fallback = MaterialTypeMapServiceFbk.class)
public interface MaterialTypeMapService {

    @PostMapping("/materialTypeMapInsert")
    Result insert(List<MaterialTypeMap> materialTypeMapList);

    @PutMapping("/materialTypeMapUpdate")
    Result update(MaterialTypeMapMix materialTypeMapMix);

    /**
     * 查询材料信息的主列表
     * @return
     */
    @GetMapping("/materialTypeMapFindList")
    public Result materialTypeMapFindList(@RequestParam(value = "materalType", required = false) Byte materalType,
                                          @RequestParam(value = "mapRule", required = false) String mapRule,
                                          @RequestParam("pageNum") Integer pageNum,
                                          @RequestParam("pageSize")Integer pageSize);


}
