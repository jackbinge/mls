package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.entity.ykAi.TRolePrivilege;
import java.util.List;
import org.apache.ibatis.annotations.Param;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/8     lipeng      原始版本
 * 文件说明:  
 */
public interface TRolePrivilegeMapper {
    int deleteByPrimaryKey(Long id);

    int insert(TRolePrivilege record);

    int insertSelective(TRolePrivilege record);

    TRolePrivilege selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(TRolePrivilege record);

    int updateByPrimaryKey(TRolePrivilege record);

    int updateBatch(List<TRolePrivilege> list);


}