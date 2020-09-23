package com.wiseq.cn.commons.utils;

import com.wiseq.cn.commons.annotation.NumberFormat;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

/**
 * 版本        修改时间              作者      修改内容
 * V1.0     2019/9/27 上午 10:08       liuchao    原始版本
 * 文件说明: 数据工具类
 */
public class NumberUtil {
    private static final String METHOD_NAME = "format";

    /**
     * 对某些字段进行保留小数点后几位
     *
     * @param t
     * @param <T>
     */
    public static <T> void format(T t) {
        Field[] fields = ((T) t).getClass().getDeclaredFields();
        if (null != fields)
            for (Field field : fields) {
                field.setAccessible(true);
                Annotation annotation = field.getAnnotation(NumberFormat.class);
                if (null != annotation) {
                    Method[] methods = annotation.annotationType().getDeclaredMethods();
                    if (null != methods)
                        for (Method method : methods) {
                            if (!method.isAccessible())
                                method.setAccessible(true);
                            try {
                                String methodName = method.getName();
                                if (methodName.equals(METHOD_NAME)) {
                                    Integer o = (Integer) method.invoke(annotation, null);
                                    StringBuffer patten = new StringBuffer("%");
                                    if (null != o) patten.append(".").append(o).append("f");
                                    Object o1 = field.get(t);
                                    if (null != o1) {
                                        String val = String.format(patten.toString(), o1);
                                        field.set(t, Double.valueOf(val));
                                    }
                                }
                            } catch (IllegalAccessException e) {
                                e.printStackTrace();
                            } catch (InvocationTargetException e) {
                                e.printStackTrace();
                            }
                        }
                }

            }
    }
}
