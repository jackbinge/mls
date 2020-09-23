package com.wiseq.cn.ykAi.service;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TTypeMachine;
import org.springframework.transaction.annotation.Transactional;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/6      jiangbailing      原始版本
 * 文件说明:基础库-机种库
 */
public interface TTypeMachineService {
    PageInfo<TTypeMachine> selectAll(String spec, Byte processType, Boolean disabled, Integer pageNum, Integer pageSize,Integer crystalNumber);
    @Transactional
    Result insert(TTypeMachine record);

    Result deleteByPrimaryKey(Long id);

    Result updateByPrimaryKeySelective(TTypeMachine record);

    Result updateOnAndOff(TTypeMachine record);

    Result findTypeMatchineListForTest(String spec,
                                       Byte processType,
                                       Integer pageNum, Integer pageSize,Integer crystalNumber);

    Result findTypeMachineById(Long typeMachineId);
}
