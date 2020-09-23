package com.wiseq.cn.entity.webview;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明:  sysuser && department && station等关联信息组合起来的entity
 **/
@Setter
@Getter
public class User {
    private Integer id;
    //账号
    private String username;
    //用户所在部门
    private List<String> inDeptCode;
    //用户所在角色组
    private List<String> inSysRoleId;
    //用户所在岗位ID
    private List<Integer> inStationId;
}
