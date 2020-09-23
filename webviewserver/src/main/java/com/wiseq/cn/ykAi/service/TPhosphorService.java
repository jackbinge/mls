package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TPhosphor;
import com.wiseq.cn.ykAi.service.servicefbk.TPhosphorServiceFbk;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-荧光粉
 */
@FeignClient(value = "mysqldata-service/tPhosphorController", fallback = TPhosphorServiceFbk.class)
public interface TPhosphorService {
    //新增考核项
    @PostMapping("/tPhosphorInsert")
    Result insert(@RequestBody TPhosphor tPhosphor);

    //修改考核项
    @PutMapping("/tPhosphorUpdate")
    Result update(@RequestBody TPhosphor tPhosphor);

    /**
     * 查询荧光粉信息的主列表
     */
    @GetMapping("/tPhosphorFindList")
    public Result tPhosphorFindList(@RequestParam(value = "phosphorSpec", required = false) String phosphorSpec,
                                    @RequestParam(value = "disabled", required = false) Boolean disabled,
                                    @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                    @RequestParam(value = "pageSize", required = true) Integer pageSize,
                                    @RequestParam(value = "phosphorType",required = false ,defaultValue = "") String phosphorType,
                                    @RequestParam(value = "phosphorTypeId",required = false ) Integer phosphorTypeId);

    //启用禁用
    @PutMapping("/tPhosphorUpdateDisabled")
    Result updateDisabled(@RequestBody TPhosphor tPhosphor);

    //删除
    @DeleteMapping("/tPhosphorUpdateDel")
    Result updateDel(@RequestBody TPhosphor tPhosphor);

}
