package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.entity.ykAi.TUserRole;
import java.util.List;
import org.apache.ibatis.annotations.Param;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/8     lipeng      原始版本
 * 文件说明:  
 */
public interface TUserRoleMapper {
    /**
     *
     * @param id
     * @return
     * -- 废弃
     */
    List<TUserRole> findExit(Long id);

    void insert(TUserRole tUserRole);

    void updateUserRole(TUserRole tUserRole);
}