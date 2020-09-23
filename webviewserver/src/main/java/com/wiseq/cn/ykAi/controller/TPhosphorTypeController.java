package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.ykAi.service.TPhosphorTypeService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/11     jiangbailing      原始版本
 * 文件说明:
 */
@RestController
@RequestMapping("/tPhosphorTypeController")
@Api(tags = "荧光粉类别")
public class TPhosphorTypeController {
    @Autowired
    private TPhosphorTypeService tPhosphorTypeService;

    @GetMapping("/select")
    public Result select(){
        return tPhosphorTypeService.select();
    }

    @DeleteMapping("/delete")
    public Result delete(@RequestParam("id") String id){
        return tPhosphorTypeService.delete(id);
    }

    @PostMapping("/add")
    public Result add(@RequestParam("name") String name){
        return tPhosphorTypeService.add(name);
    }

    @GetMapping("/getSomeTypePosphor")
    @ApiOperation("根据荧光类别获取对应的荧光粉,可以传多个类别通过，号分割")
    public Result getSomeTypePosphor(@RequestParam("phosphorTypes") String phosphorTypes){
        return tPhosphorTypeService.getSomeTypePosphor(phosphorTypes);
    }
}
