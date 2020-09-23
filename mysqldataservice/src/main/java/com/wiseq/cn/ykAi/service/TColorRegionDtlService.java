package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.*;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/11/6       lipeng      原始版本
 * 文件说明:色区明细
 */
public interface TColorRegionDtlService {


    Result updateDelbunch(List<TColorRegionDtl> tColorRegionDtlList);

    Result tColorRegionGroupInsert(TColorRegionGroup tColorRegionGroup);

    TColorRegionDtl findtColorRegionDtlList(Long colorRegionId, String name, Byte shape);

    @Transactional
    Result tColorRegionGroupSKInsert(TColorRegionGroupSK tColorRegionGroupSK);

    @Transactional
    Result updateSk(List<SKInfoDTO> skInfoDTOS);
    @Transactional
    Result updateTy(TyInfoDTO tyInfoDTO);
    @Transactional
    Result updateFk(FkInfoDTO fkInfoDTO);
}
