package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.*;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface TBomService {
    Result bomUpdate(TBOMUpdatePage tbomUpdatePage);


    TBomListPage selectAllByTypeMachineId(Long typeMachineId,
                                          Boolean isTemp,
                                          String bomCode,
                                          Byte bomType,
                                          Integer bomSource);

    List<TABGlue> getTGlues();

    List<TChip> getTChips();

    List<TPhosphor> getTPhosphors();

    List<TScaffold> getTScaffolds();

    TBom selectBomByBomId(Long bomId);


    Map<String,Object> getSystemRecommedSetUpParameters(Long bomId);

    Result offLineRecommendBom(OffLineRecommendFrontToBack offLineRecommendFrontToBack);

    Result onLineRecommendBom(OnLineRecommendFrontToBack onLineRecommendFrontToBack);

    Result checkBomRepeatForEAS(TBom tBom);

    Result addBom(TBom tBom);

    Result getUseCurrentBomAiModelList(Long bomId);

    Result deleteBom(Long bomId);

    Result getBomMinimumWavelengthPhosphor(Long bomId);
}
