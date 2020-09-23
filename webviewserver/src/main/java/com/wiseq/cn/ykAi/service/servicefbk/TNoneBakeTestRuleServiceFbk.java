package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TOutputRequireNbakeRule;
import com.wiseq.cn.ykAi.service.TNoneBakeTestRuleService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TNoneBakeTestRuleServiceFbk implements TNoneBakeTestRuleService {
    @Override
    public Result findTOutputRequireNbakeRuleByOutputRequireId(Long outputRequireId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result edit(List<TOutputRequireNbakeRule> tOutputRequireNbakeRules) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
