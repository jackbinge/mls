package com.wiseq.cn.entity.webview;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotNull;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: factory entity
 **/
@Getter
@Setter
public class Factory {
    private Integer id;
    private String code;

    private String parentCode;
    @NotNull
    private String name;

    private Integer isdeleted;
}
