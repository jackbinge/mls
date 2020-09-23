package com.wiseq.cn.entity.annotations;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.QuHelper;
import com.wiseq.cn.commons.utils.ResultUtils;

import javax.validation.Constraint;
import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import javax.validation.Payload;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
public @interface HdfsFileName {
    String Value() default "";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}

