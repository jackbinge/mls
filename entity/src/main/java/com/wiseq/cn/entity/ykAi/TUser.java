package com.wiseq.cn.entity.ykAi;

import java.util.Date;
import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/8     lipeng      原始版本
 * 文件说明:  用户表
 */
@Data
public class TUser {
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
}