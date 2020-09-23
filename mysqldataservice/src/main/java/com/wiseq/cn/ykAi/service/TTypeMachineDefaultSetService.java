package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TTypeMachineDefaultSetFrontToBack;

import java.util.Map;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/13     jiangbailing      原始版本
 * 文件说明:
 */
public interface TTypeMachineDefaultSetService {


    Result set(TTypeMachineDefaultSetFrontToBack data);


    Map<String,Object> select(Integer typeMachineId);
}
