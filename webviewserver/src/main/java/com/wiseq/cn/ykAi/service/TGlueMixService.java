package com.wiseq.cn.ykAi.service;

import com.alibaba.fastjson.JSONObject;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TGlue;
import com.wiseq.cn.entity.ykAi.TGlueMix;
import com.wiseq.cn.ykAi.service.servicefbk.TChipServiceFbk;
import com.wiseq.cn.ykAi.service.servicefbk.TGlueMixServiceFbk;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:材料库-胶水比例
 */
@FeignClient(value = "mysqldata-service/tGlueMixController", fallback = TGlueMixServiceFbk.class)
public interface TGlueMixService {
    /**
     * 原材料库-胶水比例信息新增
     */
    @PostMapping("/tGlueMixInsert")
    Result insert(@RequestBody List<TGlueMix> tGlueMixList);

    /**
     * 原材料库-胶水比例修改
     */
    @PutMapping("/tGlueMixUpdate")
    Result update(@RequestBody List<TGlueMix> tGlueMixList);

    /**
     * 启用禁用
     */
    @PutMapping("/tGlueMixUpdateDisabled")
    Result updateDisabled(@RequestBody TGlue tGlue);

    /**
     * 逻辑删除
     */
    @DeleteMapping("/tGlueMixUpdateDel")
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
    Result findList(@RequestParam("glueSpec")String glueSpec,
                    @RequestParam("disabled")Integer disabled,
                    @RequestParam("pageNum")Integer pageNum,
                    @RequestParam("pageSize")Integer pageSize);

}
