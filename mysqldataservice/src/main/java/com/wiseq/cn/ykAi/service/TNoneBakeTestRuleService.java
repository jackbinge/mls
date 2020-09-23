package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TOutputRequireNbakeRule;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface TNoneBakeTestRuleService {
    Result findTOutputRequireNbakeRuleByOutputRequireId(Long outputRequireId);

    @Transactional
    Result edit(List<TOutputRequireNbakeRule> tOutputRequireNbakeRules);
}
