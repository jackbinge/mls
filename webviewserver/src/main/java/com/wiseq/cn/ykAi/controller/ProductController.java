package com.wiseq.cn.ykAi.controller;


import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.dataCollection.*;
import com.wiseq.cn.ykAi.service.ProductService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Api(value = "数据同步和上传")
@RequestMapping("/productController")
public class ProductController {

    @Autowired
    private ProductService productService;

    //一键同步EAS系统数据
    @GetMapping("/saveDataFromEAS")
    @ApiOperation(value = "一键同步EAS数据")
    public Result getDataFromEAS(){
        return productService.getDataFromEAS();
    }

    @GetMapping("getNoCommissioningWo")
    @ApiOperation(value = "获取未投产工单信息")
    public Result getNoCommissioningWo(@RequestParam(value = "billNumber",required = false)String billNumber,
                                       @RequestParam(value = "adminOrgName",required = false)String adminOrgName,
                                       @RequestParam(value = "productModel",required = false)String productModel,
                                       @RequestParam(value = "pageNum") Integer pageNum,
                                       @RequestParam(value = "pageSize")Integer pageSize){
        return productService.getNoCommissioningWo(billNumber,adminOrgName,productModel,pageNum,pageSize);
    }

    @GetMapping("/getCommissioningWo")
    @ApiOperation(value = "获取已投产的工单信息")
    public Result getCommissioningWo(@RequestParam(value = "billNumber",required = false)String billNumber,
                                     @RequestParam(value = "adminOrgName",required = false)String adminOrgName,
                                     @RequestParam(value = "productModel",required = false)String productModel,
                                     @RequestParam(value = "pageNum") Integer pageNum,
                                     @RequestParam(value = "pageSize")Integer pageSize){
        return productService.getCommissioningWo(billNumber,adminOrgName,productModel,pageNum,pageSize);
    }

    @GetMapping("/getFeedingDetail")
    @ApiOperation(value = "获取投料详情")
    public Result getFeedingDetail(@RequestParam(value = "billNumber",required = false)String billNumber){
        return productService.getFeedingDetail(billNumber);
    }

    @GetMapping("/judgeCommissioning")
    @ApiOperation(value = "投产信息的校验和确认")
    public Result judgeCommissioning(@RequestParam(value = "billNumber",required = false)String billNumber){
        return productService.judgeCommissioning(billNumber);
    }

    @PostMapping("/commissioning")
    @ApiOperation(value = "开始投产")
    public Result commissioning(@RequestBody CommissioningFrontToBack commissioningReal){
        return productService.commissioning(commissioningReal);
    }

    @GetMapping("/getWoDetail")
    @ApiOperation(value = "获取工单详情")
    public Result getWoDetail(@RequestParam(value = "billNumber")String billNumber){
        return productService.getWoDetail(billNumber);
    }

    @PostMapping("/index")
    public Result index(String name){
        return ResultUtils.success(name);
    }
}
