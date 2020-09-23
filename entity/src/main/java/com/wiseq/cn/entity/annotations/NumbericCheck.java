package com.wiseq.cn.entity.annotations;

import com.wiseq.cn.commons.utils.QuHelper;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

public class NumbericCheck implements ConstraintValidator<Numberic,Object> {
    private String message;
    private Integer maxValue = Integer.MAX_VALUE;
    private Integer minValue = Integer.MIN_VALUE;
    private boolean isCheckValue = false;

    public void initialize(Numberic constraintAnnotation) {
        this.message=constraintAnnotation.message();
        this.maxValue=constraintAnnotation.maxValue();
        this.minValue=constraintAnnotation.minValue();
        this.isCheckValue=constraintAnnotation.isCheckValue();
    }

    public boolean isValid(Object o, ConstraintValidatorContext constraintValidatorContext) {
        if(o==null){
            return true;
        }
        String snum=o.toString();
        if(isCheckValue) {
            if (!QuHelper.isNumeric(snum)) {
                return false;
            }
            Integer inum=Integer.parseInt(snum);
            if(inum>maxValue||inum<minValue){
                this.message="数字不在指定范围内";
                return false;
            }
            return true;
        }
        return false;
    }
}
