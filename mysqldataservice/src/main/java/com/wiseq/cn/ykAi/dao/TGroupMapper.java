package com.wiseq.cn.ykAi.dao;


import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TGroup;
import org.apache.ibatis.annotations.Param;

import java.util.LinkedHashMap;
import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/11     lipeng      原始版本
 * 文件说明:
 */
public interface TGroupMapper {


    List<TGroup> findGroupTree(@Param("code") String code, @Param("name") String name);

    List<TGroup> findExist(@Param("name") String name, @Param("parentId") Long parentId);

    List<TGroup> findChildExist(@Param("parentId") Long parentId);

    void insert(TGroup tGroup);

    void updateDel(TGroup tGroup);

    Result findProductionCodeList(@Param("id") Long id);

    Result findProductionNoCodeList();

    Result productionCodeinsert(TGroup tGroup);

    List<TGroup> findCodeExist(@Param("code") String code);

    Result productionCodeUpdate(TGroup tGroup);

    /**
     * 获取生产车间列表
     *
     * @return
     */
    List<LinkedHashMap<String, Object>> getProductionList();


    /**
     * 修改EasId
     *
     * @return
     */
    int updateMapEasId(@Param("mapEasId") String mapEasId, @Param("id") Long id);

    /**
     * 获取生产车间有编码的列表
     *
     * @return
     */
    List<LinkedHashMap<String, Object>> getProductionMapEASIdList(@Param("id") Long id);

    /**
     * 重复校验
     *
     * @param mapEasId
     * @param id
     * @return
     */
    List<LinkedHashMap<String, Object>> findExit(@Param("mapEasId") String mapEasId, @Param("id") Long id);

    /**
     * 获取没有EAS工单ID的组织列表
     */
    List<LinkedHashMap<String, Object>> getNoMapEasIdShopList();
}