package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.ykAi.service.servicefbk.TestServiceFbk;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;


/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/19     jiangbailing      原始版本
 * 文件说明: 测试
 */
@FeignClient(value = "mysqldata-service/task", fallback = TestServiceFbk.class)
public interface TestService {

    @GetMapping("/test")
    Result getTest();


    @GetMapping("/helloTest")
    Result getHelloTest(@RequestParam("id") Long id);

}
