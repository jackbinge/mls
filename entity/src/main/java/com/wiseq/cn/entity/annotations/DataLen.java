package com.wiseq.cn.entity.annotations;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(value = ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = DataLenCheck.class)
public @interface DataLen {
    int length();

    String message() default "参数长度合法";

    Class thisClassName();

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
