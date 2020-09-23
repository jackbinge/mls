package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/8     lipeng      原始版本
 * 文件说明:  角色和权限关联表
 */
@Data
public class TRolePrivilege {
    private Long id;

    private Long privilegeId;

    private Long roleId;
}