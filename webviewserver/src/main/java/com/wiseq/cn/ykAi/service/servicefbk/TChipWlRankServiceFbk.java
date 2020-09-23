package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TChipWlRank;
import com.wiseq.cn.ykAi.service.TChipWlRankService;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-波段
 */
@Service
public class TChipWlRankServiceFbk implements TChipWlRankService {

    @Override
    public Result batchInsert(List<TChipWlRank> tChipWlRankList) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result batchupdate(List<TChipWlRank> tChipWlRankList) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result findAll(Long chipId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result updateStatus(TChipWlRank tChipWlRank) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
