package com.wiseq.cn.entity.annotations;

import com.wiseq.cn.commons.utils.QuHelper;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.lang.reflect.Field;


public class InitIntegerCheck implements ConstraintValidator<InitInteger,Object> {

    private  String message;
    private  String initValue;
    private  Class   thisClassName;

    public void initialize(InitInteger constraintAnnotation) {
        this.message=constraintAnnotation.message();
        this.initValue=constraintAnnotation.initValue();
        this.thisClassName=constraintAnnotation.thisClassName();

    }

    public  boolean isValid(Object o, ConstraintValidatorContext constraintValidatorContext) {
        if(o==null){
            return false;
        }

        String  strNum= o.toString();
        boolean isNum=QuHelper.isNumeric(strNum);
        if(isNum){
            return true;
        }else{
            Field[] fields = thisClassName.getDeclaredFields();
            for (Field field : fields) {
                boolean isthisAnnotation = field.isAnnotationPresent(InitInteger.class);
                if (isthisAnnotation) {
                    InitInteger annotation = field.getAnnotation(InitInteger.class);
                    String fieldName= field.getName();
                    o=this.initValue;
                    try {
                        field.setAccessible(true);

                        // Integer String
                        String a="100";
                        Object object= thisClassName.newInstance();//指明是什么类。

                        field.set(object,"89");
                    } catch (InstantiationException e) {
                        e.printStackTrace();
                    } catch (IllegalAccessException e) {
                        e.printStackTrace();
                    }

                    try {
                       //对私有字段的访问取消权限检查。暴力访问。

                        field.set(annotation,"55");
                    } catch (IllegalAccessException e) {


                    }

//                    Method me = null;
//                    try {
//
//                        me = thisClassName.getDeclaredMethod("setAge", String.class);
//                        me.invoke(thisClassName.newInstance(),"20");
//                    } catch (NoSuchMethodException e) {
//                        e.printStackTrace();
//                    } catch (IllegalAccessException e) {
//                        e.printStackTrace();
//                    } catch (InstantiationException e) {
//                        e.printStackTrace();
//                    } catch (InvocationTargetException e) {
//                        e.printStackTrace();
//                    }

                }

            }
            return true;
        }
    }
}
