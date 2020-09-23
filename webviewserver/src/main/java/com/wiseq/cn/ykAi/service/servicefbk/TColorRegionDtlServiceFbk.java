package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.*;
import com.wiseq.cn.ykAi.service.TColorRegionDtlService;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:色区色块
 */
@Service
public class TColorRegionDtlServiceFbk implements TColorRegionDtlService {


    @Override
    public Result tColorRegionUpdateDel(List<TColorRegion> tColorRegionList) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result tColorRegionGroupInsert(TColorRegionGroup tColorRegionGroup) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result tColorRegionGroupkInsert(TColorRegionGroupSK tColorRegionGroupSK) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result tColorRegionDtlFindList(Long colorRegionId, String name, Byte shape) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result updateSk(List<SKInfoDTO> skInfoDTOS) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result updateTy(TyInfoDTO tyInfoDTO) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result updateFk(FkInfoDTO fkInfoDTO) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
