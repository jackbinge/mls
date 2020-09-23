package com.wiseq.cn.entity.annotations;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2018/11/6 14:04  jiangbailing 原始版本
 * 文件说明: 检查该参数是否是数字类型，并且在指定的范围内
 **/

@Target(ElementType.FIELD)// 字段、枚举的常量
@Retention(RetentionPolicy.RUNTIME)// 注解会在class字节码文件中存在，在运行时可以通过反射获取到
@Constraint(validatedBy = NumbericCheck.class)
public @interface Numberic {

    String message() default "非法数字";

    int maxValue() default  Integer.MAX_VALUE;

    int minValue() default  Integer.MIN_VALUE;

    boolean isCheckValue() default false;//是否检查范围

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
