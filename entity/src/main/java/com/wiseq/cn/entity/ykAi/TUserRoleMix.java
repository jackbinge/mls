package com.wiseq.cn.entity.ykAi;

import com.wiseq.cn.entity.webview.User;
import lombok.Data;

import java.util.Date;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/8     lipeng      原始版本
 * 文件说明:  用户表
 */
@Data
public class TUserRoleMix {

    /**
    * 用户信息
    */
    private TUser tUser;

    /**
     * 用户角色对应关系
     */
    private TUserRole tUserRole;
}