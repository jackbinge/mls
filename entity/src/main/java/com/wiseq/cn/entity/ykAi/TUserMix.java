package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.Date;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/8     lipeng      原始版本
 * 文件说明:  用户信息混合表
 */
@Data
public class TUserMix {
    private Long id;

    /**
     * 组织id
     */
    private Long groupId;

    /**
     * 用户名
     */
    private String username;

    /**
     * 账户
     */
    private String account;

    private String password;

    /**
     * 是否禁用 false 不禁用 true 禁用
     */
    private Boolean disabled;

    /**
     * false正常、true 删除
     */
    private Boolean isDelete;

    /**
     * 创建时间
     */
    private Date createTime;

    /**
     * 角色Id
     */
    private Long roleId;
    //角色名称
    private String rname;
    //角色备注
    private String rremark;
    //角色是否禁用
    private Boolean rdisabled;
//权限ID
//    private Long privilegeId;
////权限关联父ID
//    private Long parentId;
////权限名称
//    private String pname;
////权限备注
//    private String premark;
    /**
     * 组织ID
     */
    private Long parentId;

    //地域名称
    private String gname;

    /**
     * 关联至eas组织结构id
     */
    private String mapEasId;

    /**
     * 父级路径
     */
    private String parentPass;

    /**
     * 组织级别,建议创建一张表，关联相关id
     */
    private String leavel;


}