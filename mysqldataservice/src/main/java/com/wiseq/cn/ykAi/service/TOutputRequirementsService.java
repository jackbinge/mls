package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.exception.QuException;
import com.wiseq.cn.entity.ykAi.TColorRegionSK;
import com.wiseq.cn.entity.ykAi.TColorTolerance;
import com.wiseq.cn.entity.ykAi.TOutputRequirements;
import com.wiseq.cn.entity.ykAi.TOutputRequirementsAll;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

public interface TOutputRequirementsService {
    List<TOutputRequirements> selectByTypeMachineId(Long typeMachineId,
                                                    Byte outputKind,
                                                    Boolean isTemp, String code);

    Result selectTOutputRequirementsByPK(Long outputId);

    TOutputRequirements selectTOutputRequirementsByPKNOResult(Long outputId);

    List<TColorTolerance> findTColorTolerance(Long typeMachineId);

    List<TColorRegionSK> findTColorRegionSK(Long typeMachineId);

    @Transactional
    Result updateOutputRequirements(TOutputRequirementsAll tOutputRequirementsAll) throws QuException;

    Result findAllTColorRegionSKs(Long typeMachineId);

    Result findAllTColorTolerance(Long typeMachineId);

    Result centerpointMethod(String jsonStr) throws QuException;


    Result deleteOutputRequiremet(Long outputId);
}
