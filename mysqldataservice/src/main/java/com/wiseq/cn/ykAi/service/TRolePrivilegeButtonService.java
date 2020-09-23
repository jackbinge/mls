package com.wiseq.cn.ykAi.service;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.RoleEdit;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/11/12       lipeng      原始版本
 * 文件说明:角色菜单按钮配置管理
 */
public interface TRolePrivilegeButtonService {


    int updateDisabled(Long roleId, Boolean disable);

    int updateDel(Long roleId);

    PageInfo findList(String name, Boolean disabled,Long groupId, Integer pageNum, Integer pageSize);


    Result edit(RoleEdit roleEdit);
}
