package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.EditTModelFormulaForPage;
import com.wiseq.cn.entity.ykAi.TAiModel;
import com.wiseq.cn.ykAi.service.TAiModelService;
import org.springframework.stereotype.Service;

@Service
public class TAiModelServiceFbk implements TAiModelService {
    @Override
    public Result findModelList(String spec, Byte processType, Integer pageNum, Integer pageSize) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result findChipMixByTypeMachineId(Long id) {

        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result addProductCollocation(TAiModel record) {

        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result findMoldeList(Long typeMachineId, String outputRequireMachineCode, String bomCode) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result addModelFormula(EditTModelFormulaForPage editTModelFormulaForPage) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result updateModelFormula(EditTModelFormulaForPage editTModelFormulaForPage) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result deleteModelByPrimaryKey(Long id) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result selectFormulaUpdteLog(Long modelBomId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result selectAiModelChip(Long modelId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result selectRatioTargetParameter(Long bsFormulaUpdateLogId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
