package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.entity.ykAi.TRole;

import java.util.List;

import com.wiseq.cn.entity.ykAi.TRoleGroup;
import com.wiseq.cn.entity.ykAi.TRolePrivilege;
import com.wiseq.cn.entity.ykAi.TUserRole;
import org.apache.ibatis.annotations.Param;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/8     lipeng      原始版本
 * 文件说明:
 */
public interface TRoleMapper {

    int insert(TRole record);

    /**
     * 角色新增
     *
     * @param record
     * @return
     */
    int insertSelective(TRole record);


    /**
     * 角色编辑
     *
     * @param record
     * @return
     */
    int updateByPrimaryKeySelective(TRole record);


    /**
     * 启用禁用
     *
     * @param roleId
     * @param disable
     * @return
     */
    int disable(@Param("roleId") Long roleId, @Param("disable") Boolean disable);

    /**
     * 删除角色权限和角色
     *
     * @param id
     * @return
     */
    int deleteRoleAndPrivilege(@Param("id") Long id);


    /**
     * 角色列表查询包含其权限
     *
     * @param name
     * @param disabled
     * @param groupId
     * @return
     */
    List<TRoleGroup> findList(@Param("name") String name, @Param("disabled") Boolean disabled, @Param("groupId") Long groupId);


    /**
     * 删除角色的所有权限
     *
     * @param id
     * @return
     */
    int deleteRolePrivilege(@Param("id") Long id);

    /**
     * 重复校验
     *
     * @param name
     * @param groupId
     * @param id
     * @return
     */
    int findRoleExit(@Param("name") String name, @Param("groupId") Long groupId, @Param("id") Long id);

    /**
     * 批量新增
     * @param list
     * @return
     */
    int batchInsertRoleWithPrivilege(@Param("list") List<TRolePrivilege> list);
}