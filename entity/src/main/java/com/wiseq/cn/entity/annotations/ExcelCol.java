package com.wiseq.cn.entity.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 版本        修改时间        作者        修改内容
 * V1.0        ------        songlp       原始版本
 * 文件说明: Exce导出字段注释
 **/
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface ExcelCol {
    String value()    default "";
}
