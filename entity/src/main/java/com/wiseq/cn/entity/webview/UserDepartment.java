package com.wiseq.cn.entity.webview;

import com.wiseq.cn.entity.annotations.QuIndex;
import lombok.Getter;
import lombok.Setter;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: 用户与部门entity
 **/
@Setter
@Getter
public class UserDepartment {
    @QuIndex
    private Integer id;
    @QuIndex
    private Integer deptId;
    @QuIndex
    private Integer userid;
}
