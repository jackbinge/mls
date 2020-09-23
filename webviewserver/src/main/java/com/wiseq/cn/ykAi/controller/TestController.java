package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/19     jiangbailing      原始版本
 * 文件说明:
 */
@RestController
@RequestMapping(value = "/task")
public class TestController {


    @Autowired
    HttpServletRequest request;

    @GetMapping("/test")
    Result getTest(){
        //System.out.println(request.getHeader("token"));
        String id=request.getHeader("ids");
        return  ResultUtils.success(id);

    }


    @GetMapping("/helloTest")
    Result getHelloTest(@RequestParam("id") Long id){
        //System.out.println(request.getHeader("token"));
        //String id=request.getHeader("ids");
        return  ResultUtils.success(id);

    }

}
