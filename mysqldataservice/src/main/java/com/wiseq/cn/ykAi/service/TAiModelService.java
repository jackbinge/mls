package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.*;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

public interface TAiModelService {
    Result findModelList(String spec, Byte processType, Integer pageNum, Integer pageSize);

    Result findChipMixByTypeMachineId(Long id);


   /* @Transactional
    Result addProductCollocation(TAiModel record);*/

    @Transactional
    Result addProductCollocationReturnId(TAiModel record);

    /**
     * 调整出货比例中心点版新增配比
     * @param record
     * @return
     */
   /* Result  adjustmentCentterPoint(TAiModel record);*/

    Result findMoldeList(Long typeMachineId,
                         String outputRequireMachineCode,
                         String bomCode);


    @Transactional
    Result addModelFormula(EditTModelFormulaForPage editTModelFormulaForPage);

    @Transactional
    Result updateModelFormula(EditTModelFormulaForPage editTModelFormulaForPage);

    Result deleteModelByPrimaryKey(Long id);

    Result selectFormulaUpdteLog(Long modelBomId);

    List<Map<String, Object>> selectAiModelChip(Long modelId);

    //获取建立次配比时的目标参数
    BsFormulaTargetParameter selectRatioTargetParameter(Long bsFormulaUpdateLogId);

    String checkoutAiModel(Long modelId);
}
