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
 * 文件说明: 自定义密码检查注解
 **/
@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = QuPasswordCheck.class)
public @interface QuPassword {
    String message() default "密码非法";

    int maxLength() default 20;

    int minLength() default 6;

    boolean isNumberic() default false;

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
