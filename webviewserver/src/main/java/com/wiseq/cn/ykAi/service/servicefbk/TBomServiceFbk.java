package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.OffLineRecommendFrontToBack;
import com.wiseq.cn.entity.ykAi.OnLineRecommendFrontToBack;
import com.wiseq.cn.entity.ykAi.TBOMUpdatePage;
import com.wiseq.cn.entity.ykAi.TBom;
import com.wiseq.cn.ykAi.service.TBomService;
import org.springframework.stereotype.Service;

@Service
public class TBomServiceFbk implements TBomService {
    @Override
    public Result bomUpdate(TBOMUpdatePage tbomUpdatePage) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result selectAllByTypeMachineId(Long typeMachineId, Boolean isTemp, String bomCode, Byte bomType, Integer bomSource) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }


    @Override
    public Result getTGlues() {

        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getTChips() {

        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getTPhosphors() {

        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getTScaffolds() {

        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result selectBomId(Long bomId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getSystemRecommedSetUpParameters(Long bomId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result offLineRecommendBom(OffLineRecommendFrontToBack offLineRecommendFrontToBack) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result onLineRecommendBom(OnLineRecommendFrontToBack onLineRecommendFrontToBack) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }


    @Override
    public Result checkBomRepeat(TBom tBom) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getUseCurrentBomAiModelList(Long bomId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result addBom(TBom tBom) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result deleteBom(Long bomId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getBomMinimumWavelengthPhosphor(Long bomId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }


}
