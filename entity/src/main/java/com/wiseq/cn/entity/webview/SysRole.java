package com.wiseq.cn.entity.webview;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.Size;
import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: 角色组entity
 **/
@Setter
@Getter
public class SysRole {
    private String id;
    @Size(min=1, max=100,message = "角色英文名称长度为1-100")
    private String name;
    @Size(min=1, max=100,message = "角色中文名称长度为1-100")
    private String cnname;
    @ApiModelProperty(hidden = true)
    private Integer isdeleted;
    private List<Integer> roleMenuList;
}
