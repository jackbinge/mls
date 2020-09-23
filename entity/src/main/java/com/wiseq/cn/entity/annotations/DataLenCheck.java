package com.wiseq.cn.entity.annotations;

import org.springframework.util.StringUtils;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.lang.reflect.Field;

public class DataLenCheck implements ConstraintValidator<DataLen, Object> {

    private String message;
    private int length;
    private static Class thisClassName;

    public void initialize(DataLen constraintAnnotation) {
        this.message = constraintAnnotation.message();
        this.length = constraintAnnotation.length();
        this.thisClassName = constraintAnnotation.thisClassName();

    }

    public boolean isValid(Object o, ConstraintValidatorContext constraintValidatorContext) {
        Field[] fields = thisClassName.getDeclaredFields();
        for (Field field : fields) {// 遍历
            boolean isThisAnnotation = field.isAnnotationPresent(DataLen.class);
            if (isThisAnnotation) {
                DataLen dataLen = field.getAnnotation(DataLen.class);
                if (null != dataLen) {
                    try {
                        field.setAccessible(true);
                        // 获取属性值
                        String paramName = String.valueOf(field.get(thisClassName.newInstance()));
                        if (StringUtils.isEmpty(paramName))
                            return true;
                        // 指定的长度
                        int len = dataLen.length();
                        // 数据的长度
                        int vaLen = paramName.length();
                        // 一个个赋值
                        if (vaLen < len)
                            return true;
                        else
                            return false;
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }
        return true;
    }

}
