package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TScaffold;
import com.wiseq.cn.ykAi.service.servicefbk.TScaffoldServiceFbk;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-支架
 */
@FeignClient(value = "mysqldata-service/tScaffoldController", fallback = TScaffoldServiceFbk.class)
public interface TScaffoldService {
    //新增支架
    @PostMapping("/tScaffoldInsert")
    Result insert(@RequestBody TScaffold tScaffold);

    //修改支架
    @PutMapping("/tScaffoldUpdate")
    Result update(@RequestBody TScaffold tScaffold);

    //查询主列表
    @GetMapping("/tScaffoldFindList")
    Result findList(@RequestParam(value = "scaffoldSpec",required = false) String scaffoldSpec,
                    @RequestParam(value = "disabled",required = false) Boolean disabled,
                    @RequestParam("pageNum") Integer pageNum,
                    @RequestParam("pageSize") Integer pageSize,
                    @RequestParam(value = "scaffoldType", required = false) Byte scaffoldType);

    //启用禁用
    @PutMapping("/tScaffoldUpdateDisabled")
    Result updateDisabled(@RequestBody TScaffold tScaffold);

    //删除
    @DeleteMapping("/tScaffoldUpdateDel")
    Result updateDel(@RequestBody TScaffold tScaffold);

}
