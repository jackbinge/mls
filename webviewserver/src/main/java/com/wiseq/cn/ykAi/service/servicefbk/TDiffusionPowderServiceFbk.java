package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TDiffusionPowder;
import com.wiseq.cn.ykAi.service.TDiffusionPowderService;
import org.springframework.stereotype.Service;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-扩散粉
 */
@Service
public class TDiffusionPowderServiceFbk implements TDiffusionPowderService {

    @Override
    public Result insert(TDiffusionPowder tDiffusionPowder) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result update(TDiffusionPowder tDiffusionPowder) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result findList(String diffusionPowderSpec, Boolean disabled, Integer pageNum, Integer pageSize) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result updateDisabled(TDiffusionPowder tDiffusionPowder) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result updateDel(TDiffusionPowder tDiffusionPowder) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
