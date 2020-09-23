package com.wiseq.cn.entity.annotations;


import com.wiseq.cn.commons.exception.QuException;
import com.wiseq.cn.commons.utils.QuHelper;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: 小于1的整数注解
 **/
public class QuIndexCheck implements ConstraintValidator<QuIndex, Object> {
    private String message;
    private int minValue = 6;

    public void initialize(QuIndex constraint) {
        this.message = constraint.message();
        this.minValue = constraint.minValue();
    }


    public boolean isValid(Object obj, ConstraintValidatorContext context) throws QuException {

        if (obj==null) {
            return true;
        }

        String objStr = obj.toString();
        if(!QuHelper.isNumeric(objStr)){
            return false;
        }

        if(QuHelper.stringToInteger(objStr) < minValue){
            return false;
        }

        return true;
    }
}
