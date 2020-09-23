package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TOutputRequireBeforeTestRule;
import com.wiseq.cn.ykAi.service.TBeforeTestRuleService;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.List;

@Service
public class TBeforeTestRuleServiceFbk implements TBeforeTestRuleService {
    @Override
    public Result findDtlByOutputRequireId(Long outputRequireId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result edit(@RequestBody List<TOutputRequireBeforeTestRule> tOutputRequireBeforeTestRules) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
