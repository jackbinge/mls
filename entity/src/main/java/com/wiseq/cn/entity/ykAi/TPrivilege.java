package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class TPrivilege {
    private Long id;

    /**
    * 功能模块名称，页面名称，导航名称
    */
    private String name;

    /**
    * 父菜单Id
    */
    private Long parentId;

    /**
    * 路由名称
    */
    private String router;

    /**
    * 路由路径
    */
    private String routerPath;

    /**
    * 标识该权限是否为按钮级别，1 按钮级别 0 菜单级别
    */
    private Byte kind;

    /**
     * 用户id
     */
    private Long userId;

    /**
     * 子集
     */
    private List<TPrivilege>  childList;

    /**
     *
     */
    private List<TPrivilege>  buttonList;
}