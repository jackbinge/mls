package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TTypeMachine;
import com.wiseq.cn.ykAi.service.servicefbk.TTypeMachineServiceFbk;
import io.swagger.annotations.ApiOperation;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

@FeignClient(value = "mysqldata-service/tTypeMachineController",fallback = TTypeMachineServiceFbk.class)
public interface TTypeMachineService {
    @GetMapping("/selectAll")
    @ApiOperation(value = "查询")
    Result selectAll(@RequestParam(name = "spec",required =false)String spec,
                     @RequestParam(name = "processType",required =false) Byte processType,
                     @RequestParam(name = "disabled" ,required = false) Boolean disabled,
                     @RequestParam("pageNum") Integer pageNum,
                     @RequestParam("pageSize")Integer pageSize,
                     @RequestParam(name = "crystalNumber",required = false) Integer crystalNumber);

    @PostMapping("/insert")
    @ApiOperation(value = "新增")
    Result insert(@RequestBody TTypeMachine record);

    @DeleteMapping("/delete")
    @ApiOperation(value = "删除")
    Result delete(@RequestParam(name = "id") Long id);


    @PutMapping("/update")
    @ApiOperation(value = "修改机种")
    Result updateByPrimaryKeySelective(@RequestBody TTypeMachine record);

    @PutMapping("/onAndOff")
    @ApiOperation(value = "机种库禁用启用")
    Result updateOnAndOff(@RequestBody TTypeMachine record);


    @GetMapping("/findTypeMatchineListForTest")
    @ApiOperation(value = "测试规则首页列表")
    public Result findTypeMatchineListForTest( @RequestParam(name = "spec",required =false)String spec,
                                               @RequestParam(name = "processType",required =false)Byte processType,
                                               @RequestParam("pageNum")Integer pageNum,
                                               @RequestParam("pageSize")Integer pageSize,
                                               @RequestParam(name = "crystalNumber",required = false) Integer crystalNumber);


    @GetMapping("/findTypeMachineById")
    @ApiOperation(value = "通过机种id获取出货要求")
    public Result findTypeMachineById(@RequestParam("typeMachineId") Long typeMachineId);
}
