package com.wiseq.cn.commons.entity;

import lombok.Data;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: 返回json统一封装提供类
 **/
@Data
public class Result<T> {
    //code
    private Integer code;
    //描述
    private String message;
    //返回的object
    T data;
}
