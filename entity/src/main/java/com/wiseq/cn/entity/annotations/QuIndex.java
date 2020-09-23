package com.wiseq.cn.entity.annotations;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: 小于1的整数注解
 **/
@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = QuIndexCheck.class)
public @interface QuIndex {
    String message() default "该值为大于1的正整数";

    int minValue() default 1;

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
