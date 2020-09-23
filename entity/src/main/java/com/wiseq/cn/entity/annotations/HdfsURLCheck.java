package com.wiseq.cn.entity.annotations;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2018/11/6 13:59  jiangbailing 原始版本
 * 文件说明: url是否是hdfs路径
 **/

@Target(ElementType.FIELD)// 字段、枚举的常量
@Retention(RetentionPolicy.RUNTIME)// 注解会在class字节码文件中存在，在运行时可以通过反射获取到
@Constraint(validatedBy = HdfsURLCheckRun.class)
public @interface HdfsURLCheck {
    String message() default "非法的HDFS URL地址";
    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
