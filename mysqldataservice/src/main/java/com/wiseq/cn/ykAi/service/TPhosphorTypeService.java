package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;

import java.util.List;
import java.util.Map;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/11     jiangbailing      原始版本
 * 文件说明:
 */
public interface TPhosphorTypeService {
    Result add(String name);

    Result delete(String id);

    List<Map<String,Object>> select();

    List<Map<String, Object>> getSomeTypePosphor(String phosphorTypes);
}
