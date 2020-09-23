package com.wiseq.cn.ykAi.dao;


import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.MaterialTypeMap;
import com.wiseq.cn.entity.ykAi.MaterialTypeMapForPage;
import com.wiseq.cn.entity.ykAi.MaterialTypeRule;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/8     lipeng      原始版本
 * 文件说明:
 */
public interface MaterialTypeMapMapper {

    int insert(MaterialTypeMap materialTypeMap);

    List<MaterialTypeMap> findExist(@Param("mapRule") String mapRule, @Param("id") Long id);

    int update(MaterialTypeMap materialTypeMap);

    int updateDel(MaterialTypeMap materialTypeMap);

    /**
     * 材料类型
     *
     * @param materalType
     * @return
     */
    List<MaterialTypeMapForPage> findList(@Param("materalType") Byte materalType);

    /**
     * 材料类型对应的规则
     *
     * @param mapRule
     * @param materalType
     * @return
     */
    List<MaterialTypeRule> findRuleToType(@Param("mapRule") String mapRule, @Param("materalType") Byte materalType);
}