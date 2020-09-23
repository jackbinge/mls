package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TEqptValveGroupMix;
import com.wiseq.cn.ykAi.service.servicefbk.TChipServiceFbk;
import com.wiseq.cn.ykAi.service.servicefbk.TEqptValveGroupMixServiceFbk;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:点胶设备库编辑
 */
@FeignClient(value = "mysqldata-service/tEqptValveGroupMixController", fallback = TEqptValveGroupMixServiceFbk.class)
public interface TEqptValveGroupMixService {

    @PutMapping("/tEqptValveGroupMixUpdate")
    Result update(@RequestBody TEqptValveGroupMix tEqptValveGroupMix);
}
