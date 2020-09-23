package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.MaterialTypeMap;
import com.wiseq.cn.entity.ykAi.MaterialTypeMapMix;
import com.wiseq.cn.ykAi.service.MaterialTypeMapService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/11/8      lipeng      原始版本
 * 文件说明:材料类型编码
 */
@RestController
@RequestMapping("/materialTypeMapController")
public class MaterialTypeMapController {
    @Autowired
    MaterialTypeMapService materialTypeMapService;

    /**
     * 材料类型编码新增
     */
    @PostMapping("/materialTypeMapInsert")
    public Result materialTypeMapinsert(@RequestBody List<MaterialTypeMap> materialTypeMapList) {
        return materialTypeMapService.insert(materialTypeMapList);

    }

    /**
     * 材料类型编辑
     */
    @PutMapping("/materialTypeMapUpdate")
    public Result materialTypeMapUpdate(@RequestBody MaterialTypeMapMix materialTypeMapMix) {
        return materialTypeMapService.update(materialTypeMapMix);

    }

    /**
     * 查询材料信息的主列表
     * @return
     */
    @GetMapping("/materialTypeMapFindList")
    public Result materialTypeMapFindList(@RequestParam(value = "materalType", required = false) Byte materalType,
                                          @RequestParam(value = "mapRule", required = false) String mapRule,
                                          @RequestParam("pageNum") Integer pageNum,
                                          @RequestParam("pageSize")Integer pageSize) {
        return materialTypeMapService.findList(materalType, mapRule, pageNum, pageSize);
    }
}
