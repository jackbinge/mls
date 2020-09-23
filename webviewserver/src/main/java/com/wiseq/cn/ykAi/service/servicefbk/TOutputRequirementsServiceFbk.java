package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TOutputRequirementsAll;
import com.wiseq.cn.ykAi.service.TOutputRequirementsService;
import org.springframework.stereotype.Service;

@Service
public class TOutputRequirementsServiceFbk implements TOutputRequirementsService {
    @Override
    public Result selectByTypeMachineId(Long typeMachineId, Byte outputKind, Boolean isTemp, String code) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result findTColorTolerance(Long typeMachineId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result findTColorRegionSK(Long typeMachineId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result updateOutputRequirements(TOutputRequirementsAll tOutputRequirementsAll) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result findAllTColorRegionSKs(Long typeMachineId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result findAllTColorTolerance(Long typeMachineId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result selectTOutputRequirementsByPK(Long outputId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result centerpointMethod(String jsonStr) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result deleteOutputRequiremet(Long outputId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }



}
