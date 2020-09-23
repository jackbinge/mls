package com.wiseq.cn.entity.webview;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SysRoleMenuFunction {
    /**
     * 表ID
     */
    private Integer id;

    /**
     * 角色ID
     */
    private String roleId;

    /***
     * 模块功能ID
     */
    private String menuFunctionId;
}
