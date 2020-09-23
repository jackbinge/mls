package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TGroup;
import com.wiseq.cn.ykAi.service.TChipService;
import com.wiseq.cn.ykAi.service.TGroupService;
import org.springframework.stereotype.Service;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:组织
 */
@Service
public class TGroupServiceFbk implements TGroupService {


    @Override
    public Result tGroupFindList(String code, String name) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result tGroupinsert(TGroup tGroup) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result tGroupDel(TGroup tGroup) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result productionShopList() {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result updateGroupEasId(String mapEasId, Long id) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getProductionMapEASIdList(Long id, Integer pageNum, Integer pageSize) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getNoMapEasIdShopList() {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
