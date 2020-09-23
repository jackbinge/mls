package com.wiseq.cn.commons.exception;

import com.wiseq.cn.commons.enums.ResultEnum;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: 自定义异常继承RuntimeException,可以用于事务
 **/
public class QuException extends RuntimeException {
    private Integer code;

    public QuException(Integer code, String message) {
        super(message);
        this.code = code;
    }

    public QuException(ResultEnum resultEnum) {
        super(resultEnum.getStateInfo());
        this.code = resultEnum.getState();
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }
}

