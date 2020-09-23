package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TUser;

import java.util.List;

import com.wiseq.cn.entity.ykAi.TUserMix;
import org.apache.ibatis.annotations.Param;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/8     lipeng      原始版本
 * 文件说明:
 */
public interface TUserMapper {

    int updateDisabled(TUser tUser);

    List<TUserMix> findList(@Param("groupId") Long groupId, @Param("username") String username, @Param("disabled") Boolean disabled, @Param("rdisabled") Boolean rdisabled, @Param("gname") String gname);

    List<TUser> findExist(String account);

    int insert(TUser tUser);

    int updateUser(TUser tUser);

    int updatePass(TUser tUser);

    int updateDel(TUser tUser);

    List<TUser> findStillExist(Long id);

    TUser findUserByAccountAndPassword(@Param("account") String account, @Param("password") String password);

    /**
     * 通过账户用户列表
     *
     * @param account
     * @return
     */
    List<TUser> findUserByAccount(@Param("account") String account);

    /**
     * 没有
     * @param userId
     */
    Integer findRoleByUser(@Param("userId") Long userId);

    /**
     * 获取
     * @param userId
     * @return
     */
    TUser findUserById(@Param("userId") Long userId );
}