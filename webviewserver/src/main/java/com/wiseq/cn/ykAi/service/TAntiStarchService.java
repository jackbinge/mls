package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TAntiStarch;
import com.wiseq.cn.ykAi.service.servicefbk.TAntiStarchServiceFbk;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原原材料库-抗沉淀粉
 */
@FeignClient(value = "mysqldata-service/tAntiStarchController", fallback = TAntiStarchServiceFbk.class)
public interface TAntiStarchService {
    //新增抗沉淀粉
    @PostMapping("/tAntiStarchInsert")
    Result insert(@RequestBody TAntiStarch tAntiStarch);

    //修改抗沉淀粉
    @PutMapping("/tAntiStarchUpdate")
    Result update(@RequestBody TAntiStarch tAntiStarch);

    //查询抗沉淀粉
    @GetMapping("/tAntiStarchFindList")
    Result findList(@RequestParam(value = "antiStarchSpec", required = false) String antiStarchSpec,
                    @RequestParam(value = "disabled", required = false) Boolean disabled,
                    @RequestParam(value = "pageNum", required = true) Integer pageNum,
                    @RequestParam(value = "pageSize", required = true) Integer pageSize);

    //启用禁用
    @PutMapping("/tAntiStarchUpdateDisabled")
    Result updateDisabled(@RequestBody TAntiStarch tAntiStarch);

    //删除
    @DeleteMapping("/tAntiStarchUpdateDel")
    Result updateDel(@RequestBody TAntiStarch tAntiStarch);

}
