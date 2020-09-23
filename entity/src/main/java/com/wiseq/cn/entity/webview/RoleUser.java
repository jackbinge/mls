package com.wiseq.cn.entity.webview;

import com.wiseq.cn.entity.annotations.QuIndex;
import lombok.Getter;
import lombok.Setter;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: 用户权限组对应entity
 **/
@Setter
@Getter
public class RoleUser {
    @QuIndex
    private Integer id;
    @QuIndex
    private Integer SysUserId;
    @QuIndex
    private String  SysRoleId;
    private Integer isdeleted;

}
