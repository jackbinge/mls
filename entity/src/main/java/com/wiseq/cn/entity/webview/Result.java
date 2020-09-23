package com.wiseq.cn.entity.webview;

import lombok.Getter;
import lombok.Setter;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: Result
 **/
@Getter
@Setter
public class Result<T> {
    public Integer code;
    public String errorMassage;
    public T data;
}
