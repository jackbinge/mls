package com.wiseq.cn.ykAi.dao;


import com.wiseq.cn.entity.ykAi.TPrivilege;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TPrivilegeDao {
    int deleteByPrimaryKey(Long id);

    int insert(TPrivilege record);

    int insertSelective(TPrivilege record);

    TPrivilege selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(TPrivilege record);

    int updateByPrimaryKey(TPrivilege record);

    int updateBatch(List<TPrivilege> list);

    int batchInsert(@Param("list") List<TPrivilege> list);

    /**
     * 获取树结构
     * @return
     */
    List<TPrivilege> getBaseTree();

    /**
     * 获取用户树
     * @return
     */
    List<TPrivilege> getUserTree(@Param("userId") Long userId);


}