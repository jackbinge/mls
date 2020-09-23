package com.wiseq.cn.commons.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 版本        修改时间              作者      修改内容
 * V1.0     2019/9/27 上午 09:34       liuchao    原始版本
 * 文件说明: TODO
 */

@Target({ElementType.ANNOTATION_TYPE, ElementType.FIELD, ElementType.METHOD, ElementType.PARAMETER, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface NumberFormat {
    /**
     * 小数点后保留几位就写几
     *
     * @return
     */
    int format() default 0;

    /**
     * 是否带百分号
     *
     * @return
     */
    boolean percent() default false;
}
