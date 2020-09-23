package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.ykAi.service.TPrivilegeService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/11/11      lipeng      原始版本
 * 文件说明:生产车间编码页面
 */
@RestController
@RequestMapping("/tPrivilegeController")
@Api(description = "权限管理")
public class TPrivilegeController {
    @Autowired
    private TPrivilegeService tPrivilegeService;

    @GetMapping("/getTree")
    @ApiOperation("获取菜单的树形结构")
    Result getBaseTree(){
      return   this.tPrivilegeService.getBaseTree();
    }

    @GetMapping("/getUserTree")
    @ApiOperation("获取用户的权限树形结构")
    Result getUserTree(@RequestParam("id") Long id){
        return  this.tPrivilegeService.getUserTree(id);
    }
}
