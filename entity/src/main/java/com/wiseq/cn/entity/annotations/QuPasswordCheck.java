package com.wiseq.cn.entity.annotations;


import com.wiseq.cn.commons.exception.QuException;
import com.wiseq.cn.commons.utils.QuHelper;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: 密码检查注解
 **/
public class QuPasswordCheck implements ConstraintValidator<QuPassword, Object> {
    private String message;
    private int maxLength = 20;
    private int minLength = 6;
    private boolean isNumeric = false;

    public void initialize(QuPassword constraint) {
        this.message = constraint.message();
        this.maxLength = constraint.maxLength();
        this.minLength = constraint.minLength();
        this.isNumeric = constraint.isNumberic();
    }

    public boolean isValid(Object obj, ConstraintValidatorContext context) throws QuException {

        if (obj == null) {
            return true;
        }
        String objStr = obj.toString();

        if (objStr.length() > maxLength || objStr.length() < minLength) {
            return false;
        }
        if (isNumeric) {
            if (!QuHelper.isNumeric(objStr)) {
                return false;
            }
        }
        return true;
    }
}
