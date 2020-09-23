package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.dataCollection.CommissioningFrontToBack;
import com.wiseq.cn.entity.dataCollection.CommissioningReal;
import com.wiseq.cn.ykAi.service.servicefbk.ProductServiceFbk;
import io.swagger.annotations.ApiOperation;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient(value = "easwo-dataService/productController", fallback = ProductServiceFbk.class)
public interface ProductService {

    @GetMapping("/saveDataFromEAS")
    @ApiOperation(value = "一键同步EAS数据")
    public Result getDataFromEAS();

    @GetMapping("getNoCommissioningWo")
    @ApiOperation(value = "获取未投产工单信息")
    public Result getNoCommissioningWo(@RequestParam(value = "billNumber",required = false)String billNumber,
                                       @RequestParam(value = "adminOrgName",required = false)String adminOrgName,
                                       @RequestParam(value = "productModel",required = false)String productModel,
                                       @RequestParam(value = "pageNum") Integer pageNum,
                                       @RequestParam(value = "pageSize")Integer pageSize);

    @GetMapping("/getCommissioningWo")
    @ApiOperation(value = "获取已投产的工单信息")
    public Result getCommissioningWo(@RequestParam(value = "billNumber",required = false)String billNumber,
                                     @RequestParam(value = "adminOrgName",required = false)String adminOrgName,
                                     @RequestParam(value = "productModel",required = false)String productModel,
                                     @RequestParam(value = "pageNum") Integer pageNum,
                                     @RequestParam(value = "pageSize")Integer pageSize);

    @GetMapping("/getFeedingDetail")
    @ApiOperation(value = "获取投料详情")
    public Result getFeedingDetail(@RequestParam(value = "billNumber",required = false)String billNumber);

    @GetMapping("/judgeCommissioning")
    @ApiOperation(value = "投产信息的校验和确认")
    public Result judgeCommissioning(@RequestParam(value = "billNumber",required = false)String billNumber);

    @PostMapping("/commissioning")
    @ApiOperation(value = "开始投产")
    public Result commissioning(@RequestBody CommissioningFrontToBack commissioningReal);

    @GetMapping("/getWoDetail")
    @ApiOperation(value = "获取工单详情")
    public Result getWoDetail(@RequestParam(value = "billNumber")String billNumber);
}
