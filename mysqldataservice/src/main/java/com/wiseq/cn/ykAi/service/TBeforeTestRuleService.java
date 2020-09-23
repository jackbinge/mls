package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TOutputRequireBeforeTestRule;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


public interface TBeforeTestRuleService {
    Result findDtlByOutputRequireId(Long outputRequireId);

    @Transactional
    Result edit(List<TOutputRequireBeforeTestRule> tOutputRequireBeforeTestRules);
}
