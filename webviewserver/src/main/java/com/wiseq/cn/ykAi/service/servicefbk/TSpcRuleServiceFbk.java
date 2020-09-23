package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TSpcRuleMix;
import com.wiseq.cn.ykAi.service.TSpcRuleService;
import org.springframework.stereotype.Service;

@Service
public class TSpcRuleServiceFbk implements TSpcRuleService {
    @Override
    public Result findSpcRuleMix(Long tTypeMachineId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result edit(TSpcRuleMix tSpcRuleMix) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
