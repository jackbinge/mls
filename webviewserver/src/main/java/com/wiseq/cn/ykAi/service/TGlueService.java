package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TGlue;
import com.wiseq.cn.ykAi.service.servicefbk.TGlueMixServiceFbk;
import com.wiseq.cn.ykAi.service.servicefbk.TGlueServiceFbk;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:材料库-胶水比例
 */
@FeignClient(value = "mysqldata-service/tGlueController", fallback = TGlueServiceFbk.class)
public interface TGlueService {

    /**
     * 启用禁用
     */
    @PutMapping("/tGlueUpdateDisabled")
    Result updateDisabled(@RequestBody TGlue tGlue);

    /**
     * 逻辑删除
     */
    @DeleteMapping("/tGlueUpdateDel")
    Result updateDel(@RequestBody TGlue tGlue);

    /**
     * 查询胶水信息
     * @param glueSpec
     * @param disabled
     * @param pageNum
     * @param pageSize
     * @return
     */
    @GetMapping("/tABGlueFindList")
    Result findList(@RequestParam("glueSpec") String glueSpec,
                    @RequestParam("disabled") Boolean disabled,
                    @RequestParam("pageNum") Integer pageNum,
                    @RequestParam("pageSize") Integer pageSize);

}
