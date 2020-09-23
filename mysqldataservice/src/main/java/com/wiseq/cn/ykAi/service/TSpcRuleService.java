package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TSpcRuleMix;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface TSpcRuleService {
    TSpcRuleMix findSpcRuleMix(Long tTypeMachineId);

    @Transactional
    Result edit(TSpcRuleMix tSpcRuleMix);
}
