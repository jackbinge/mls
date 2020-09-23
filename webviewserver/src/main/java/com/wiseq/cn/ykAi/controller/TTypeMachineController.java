package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TTypeMachine;
import com.wiseq.cn.ykAi.service.TTypeMachineService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       jiangbailing      原始版本
 * 文件说明:基础库-机种库
 */
@RestController
@RequestMapping("/tTypeMachineController")
@Api(description = "基础数据库->机种库")
public class TTypeMachineController {
    @Autowired
    private TTypeMachineService tTypeMachineService;

    @GetMapping("/selectAll")
    @ApiOperation(value = "查询")
    Result selectAll(@RequestParam(name = "spec",required =false)String spec,
                     @RequestParam(name = "processType",required =false) Byte processType,
                     @RequestParam(name = "disabled" ,required = false) Boolean disabled,
                     @RequestParam("pageNum") Integer pageNum,
                     @RequestParam("pageSize")Integer pageSize,
                     @RequestParam(name = "crystalNumber",required = false) Integer crystalNumber){
        return this.tTypeMachineService.selectAll(spec, processType, disabled, pageNum, pageSize,crystalNumber);
    }

    @PostMapping("/insert")
    @ApiOperation(value = "新增")
    Result insert(@RequestBody TTypeMachine record){
        return this.tTypeMachineService.insert(record);
    }

    @DeleteMapping("/delete")
    @ApiOperation(value = "删除")
    Result delete(@RequestParam(name = "id") Long id){
        return this.tTypeMachineService.delete(id);
    }


    @PutMapping("/update")
    @ApiOperation(value = "修改机种")
    Result updateByPrimaryKeySelective(@RequestBody TTypeMachine record){
        return  this.tTypeMachineService.updateByPrimaryKeySelective(record);
    }

    @PutMapping("/onAndOff")
    @ApiOperation(value = "机种库禁用启用")
    Result updateOnAndOff(@RequestBody TTypeMachine record){
        return  this.tTypeMachineService.updateOnAndOff(record);
    }

    @GetMapping("/findTypeMatchineListForTest")
    @ApiOperation(value = "测试规则首页列表")
    public Result findTypeMatchineListForTest( @RequestParam(name = "spec",required =false)String spec,
                                               @RequestParam(name = "processType",required =false)Byte processType,
                                               @RequestParam("pageNum")Integer pageNum,
                                               @RequestParam("pageSize")Integer pageSize,
                                               @RequestParam(name = "crystalNumber",required = false) Integer crystalNumber){
        return  this.tTypeMachineService.findTypeMatchineListForTest(spec, processType, pageNum, pageSize,crystalNumber);
    }


    @GetMapping("/findTypeMachineById")
    @ApiOperation(value = "通过机种id获取出货要求")
    public Result findTypeMachineById(@RequestParam("typeMachineId") Long typeMachineId){
        return this.tTypeMachineService.findTypeMachineById(typeMachineId);
    }


}
