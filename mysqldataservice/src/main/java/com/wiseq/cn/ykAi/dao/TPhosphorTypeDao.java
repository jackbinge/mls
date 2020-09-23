package com.wiseq.cn.ykAi.dao;

import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/11     jiangbailing      原始版本
 * 文件说明:
 */
public interface TPhosphorTypeDao {
    int add(String name);

    int batchAdd(@Param("list") List<String> stringList);

    int batchDelete(@Param("listid") String listid);

    List<Map<String, Object>> select();

    int findExit(String name);

    /**
     * 通过荧光粉类别获取其对应的荧光粉
     *
     * @param phosphorTypes
     * @return
     */
    List<Map<String, Object>> getSomeTypePosphor(@Param("phosphorTypes") String phosphorTypes);


}
