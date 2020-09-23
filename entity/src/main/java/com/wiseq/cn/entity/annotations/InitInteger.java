package com.wiseq.cn.entity.annotations;


import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

@Target({ElementType.FIELD})// 方法、字段、枚举的常量
@Retention(RetentionPolicy.RUNTIME)// 注解会在class字节码文件中存在，在运行时可以通过反射获取到
@Constraint(validatedBy = InitIntegerCheck.class)
@Documented//说明该注解将被包含在javadoc中

public @interface InitInteger {
    String message() default "变量是非法的Integer数字";
    String initValue();
    Class thisClassName();

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
