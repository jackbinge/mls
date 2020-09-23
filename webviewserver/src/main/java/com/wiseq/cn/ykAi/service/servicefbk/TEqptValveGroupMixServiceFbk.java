package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TEqptValveGroupMix;
import com.wiseq.cn.ykAi.service.TChipService;
import com.wiseq.cn.ykAi.service.TEqptValveGroupMixService;
import org.springframework.stereotype.Service;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/11/5       lipeng      原始版本
 * 文件说明:点胶设备编辑
 */
@Service
public class TEqptValveGroupMixServiceFbk implements TEqptValveGroupMixService {

    @Override
    public Result update(TEqptValveGroupMix tEqptValveGroupMix) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
