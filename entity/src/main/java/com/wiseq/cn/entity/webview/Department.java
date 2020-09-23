package com.wiseq.cn.entity.webview;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: department entity
 **/
@Setter
@Getter
public class Department {
    private String id;
    private String code;
    private String name;
    private String parentId;
    @ApiModelProperty(hidden = true)
    private Integer status;
    @ApiModelProperty(hidden = true)
    private Integer type;
    @ApiModelProperty(hidden = true)
    private List<Department> children = new ArrayList<Department>();
}
