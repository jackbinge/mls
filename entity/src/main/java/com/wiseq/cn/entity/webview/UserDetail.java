package com.wiseq.cn.entity.webview;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotNull;
import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: UserDetail
 **/
@Getter
@Setter
public class UserDetail {
    @NotNull
    SysUser  sysUser;
    List<SysRole> listRole;
    /*List<Department> listDepartment;
    List<Station> listStation;*/
}
