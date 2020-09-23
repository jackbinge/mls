package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.dataCollection.CommissioningFrontToBack;
import com.wiseq.cn.entity.dataCollection.CommissioningReal;
import com.wiseq.cn.ykAi.service.ProductService;
import org.springframework.stereotype.Service;

@Service
public class ProductServiceFbk implements ProductService {
    @Override
    public Result getDataFromEAS() {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getNoCommissioningWo(String billNumber, String adminOrgName, String productModel, Integer pageNum, Integer pageSize) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getCommissioningWo(String billNumber, String adminOrgName, String productModel, Integer pageNum, Integer pageSize) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getFeedingDetail(String billNumber) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result judgeCommissioning(String billNumber) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result commissioning(CommissioningFrontToBack commissioningReal) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getWoDetail(String billNumber) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
