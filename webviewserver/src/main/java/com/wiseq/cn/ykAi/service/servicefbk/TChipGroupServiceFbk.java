package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TChipGroup;
import com.wiseq.cn.entity.ykAi.TChipWlRank;
import com.wiseq.cn.ykAi.service.TChipGroupService;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-波段
 */
@Service
public class TChipGroupServiceFbk implements TChipGroupService {

    @Override
    public Result update(TChipGroup tChipGroup) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result insert(TChipGroup tChipGroup) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
