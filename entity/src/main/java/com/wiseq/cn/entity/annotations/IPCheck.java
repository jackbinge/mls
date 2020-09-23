package com.wiseq.cn.entity.annotations;
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
@Constraint(validatedBy = IPCheckCheck.class)
public @interface IPCheck {
    String message() default "不是一个合法的IP";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}

class IPCheckCheck implements ConstraintValidator<IPCheck, Object> {

    public boolean isValid(Object o, ConstraintValidatorContext constraintValidatorContext) {

        // 要验证的字符串
        String str =o.toString();
        // 手机验证规则
        String regEx = "(2(5[0-5]{1}|[0-4]\\\\d{1})|[0-1]?\\\\d{1,2})(\\\\.(2(5[0-5]{1}|[0-4]\\\\d{1})|[0-1]?\\\\d{1,2})){3}";
        // 编译正则表达式
        Pattern pattern = Pattern.compile(regEx);
        // 忽略大小写的写法
        // Pattern pat = Pattern.compile(regEx, Pattern.CASE_INSENSITIVE);
        Matcher matcher = pattern.matcher(str);
        // 字符串是否与正则表达式相匹配
        boolean rs = matcher.matches();

        return rs;
    }
}