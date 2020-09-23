package com.wiseq.cn.entity.annotations;


import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2018/11/6 14:07  jiangbailing 原始版本
 * 文件说明: 对url地址进行检查，查看其格式是否合法
 **/

@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = URLCheckRun.class)
public @interface URLCheck {
    String message() default "非法的URL地址";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
