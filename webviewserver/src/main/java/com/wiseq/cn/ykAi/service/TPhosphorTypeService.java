package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.ykAi.service.servicefbk.TPhosphorTypeServiceFbk;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/11     jiangbailing      原始版本
 * 文件说明:
 */
@FeignClient(value = "mysqldata-service/tPhosphorTypeController" , fallback = TPhosphorTypeServiceFbk.class)
public interface TPhosphorTypeService {

    @GetMapping("/select")
    public Result select();

    @DeleteMapping("/delete")
    public Result delete(@RequestParam("id") String id);

    @PostMapping("/add")
    public Result add(@RequestParam("name") String name);


    @GetMapping("/getSomeTypePosphor")
    public Result getSomeTypePosphor(@RequestParam("phosphorTypes") String phosphorTypes);

}
