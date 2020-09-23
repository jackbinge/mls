package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TEqpt;
import com.wiseq.cn.entity.ykAi.TEqptValveGroup;
import com.wiseq.cn.ykAi.service.servicefbk.TChipServiceFbk;
import com.wiseq.cn.ykAi.service.servicefbk.TEqptValveGroupServiceFbk;
import io.swagger.annotations.ApiOperation;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:点胶设备库
 */
@FeignClient(value = "mysqldata-service/tEqptValveGroupController", fallback = TEqptValveGroupServiceFbk.class)
public interface TEqptValveGroupService {

    @PostMapping("/tEqptValveGroupInsert")
    Result insert(@RequestBody TEqptValveGroup tEqptValveGroup);

    @PutMapping("/tEqptValveGroupUpdateDisabled")
    Result updateDisabled(@RequestParam("id") Long id,@RequestParam("disable") Boolean disable);

    @DeleteMapping("/tEqptValveGroupUpdateDel")
    Result updateDel(@RequestParam("id") Long id);

    @GetMapping("/tEqptFindList")
    Result findList(@RequestParam("groupId")Long groupId,
                    @RequestParam("positon")String positon,
                    @RequestParam("assetsCode")String assetsCode,
                    @RequestParam("disabled")Boolean disabled,
                    @RequestParam("pageNum")Integer pageNum,
                    @RequestParam("pageSize")Integer pageSize);

    @GetMapping("/tEqptValveFindList")
    Result findTeqptValveList(@RequestParam("eqptId")Integer eqptId);


    /**
     * 点胶设备修改
     */
    @PutMapping("/updateEqpt")
    @ApiOperation("点胶设备修改")
    Result updateEqpt(@RequestBody TEqpt tEqpt);
}
