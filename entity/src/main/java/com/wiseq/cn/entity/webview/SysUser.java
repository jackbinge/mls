package com.wiseq.cn.entity.webview;

import com.wiseq.cn.entity.annotations.QuIndex;
import com.wiseq.cn.entity.annotations.QuPassword;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.Size;
import java.sql.Timestamp;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: SysUser
 **/
@Setter
@Getter
public class SysUser {
    @QuIndex
    private Integer id;
    @Size(min=1, max=20,message = "用户名长度为4-20")
    private String username;
    @QuPassword(minLength = 6, maxLength = 100, message ="密码长度为6-100", isNumberic = false)
    private String password;
    @ApiModelProperty(hidden = true)
    private Timestamp createTime;
    @ApiModelProperty(hidden = true)
    private Integer isdeleted;
    private String name;//姓名
    private String departmentId;
    @ApiModelProperty(hidden = true)
    private String departmentName;
}
