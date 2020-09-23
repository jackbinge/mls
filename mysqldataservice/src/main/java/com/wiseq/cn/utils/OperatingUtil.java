package com.wiseq.cn.utils;

import com.wiseq.cn.commons.annotation.NumberFormat;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.exception.QuException;
import com.wiseq.cn.commons.utils.Convert;
import com.wiseq.cn.commons.utils.QuHelper;
import com.wiseq.cn.commons.utils.ResultUtils;
import org.apache.commons.lang.time.DateUtils;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/4/29 11:20  liuchao      原始版本
 * 文件说明:  操作类
 */
public class OperatingUtil {

    private static final String PERCENT = "percent";

    /**
     * 添加结果处理
     *
     * @param flag
     * @return
     */
    public static Result addDeal(Integer flag) {
        if (flag > 999)
            if (null != ResultEnum.stateOf(flag))
                return ResultUtils.error(ResultEnum.stateOf(flag));

        if (flag < 0)
            return ResultUtils.error(ResultEnum.FAILURE);

        return ResultUtils.success();
    }

    /**
     * 更新处理
     *
     * @param flag
     * @return
     */
    public static Result updateDeal(Integer flag) {
        if (flag < 0)
            return ResultUtils.error(ResultEnum.FAILURE);

        if (flag > 999)
            if (null != ResultEnum.stateOf(flag))
                return ResultUtils.error(ResultEnum.stateOf(flag));

        return ResultUtils.success();
    }

    /**
     * 删除操作处理
     *
     * @param flag
     * @param id
     * @return
     */
    public static Result deleteDeal(Boolean flag, String id) {
        if (!QuHelper.isNumeric(id))
            throw new QuException(ResultEnum.NUMBERIC_FORMAT_ERR);
        if (Convert.toInt(id) < 1)
            throw new QuException(ResultEnum.INVALID_DATA);
        if (!flag)
            return ResultUtils.error(ResultEnum.FAILURE);

        return ResultUtils.success();
    }

    /**
     * 文件校验
     *
     * @param flag
     * @return
     */
    public static Result dataDetection(Integer flag) {
        if (flag > 999)
            if (null != ResultEnum.stateOf(flag))
                return ResultUtils.error(ResultEnum.stateOf(flag));

        if (flag < 0)
            return ResultUtils.error(ResultEnum.FAILURE);

        return ResultUtils.success();
    }

    /**
     * 序号自增
     *
     * @param result
     * @param serialNumber
     * @return
     */
    public static StringBuffer serialNumSelfAdd(StringBuffer result, String serialNumber) {
        int check = Integer.valueOf(serialNumber);
        check++;
        if (check < 10)
            result.append("00").append(check);
        else if (check < 100 && check > 9)
            result.append("0").append(check);
        else
            result.append(check);
        return result;
    }

    /**
     * 序号自增 09 10
     *
     * @param result
     * @param serialNumber
     * @return
     */
    public static StringBuffer serialNumSelfAdd1(StringBuffer result, String serialNumber) {
        int check = Integer.valueOf(serialNumber);
        check++;
        if (check < 10)
            result.append("0").append(check);
        else
            result.append(check);
        return result;
    }

    /**
     * 生成单号
     *
     * @param t               对象
     * @param timeFieldName   判定使用时间字段名
     * @param time            时间 如"1900-01-01" 生成所依据的时间
     * @param billNoFieldName 单号字段名
     * @param index           字符截取下标
     * @param identify        验证片 YZ，目检异常单 VA
     * @param <T>
     * @return
     */
    public static <T> String generateBillNo(T t, String timeFieldName, String time, String billNoFieldName, Integer index,
                                            String identify) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        StringBuffer result = new StringBuffer();
        try {
            Date creatTime = null;
            String billNo = null;
            if (null != t) {
                Field timeField = ((T) t).getClass().getDeclaredField(timeFieldName);
                Field billNoField = ((T) t).getClass().getDeclaredField(billNoFieldName);
                timeField.setAccessible(true);
                billNoField.setAccessible(true);
                creatTime = (Date) timeField.get(t);
                billNo = String.valueOf(billNoField.get(t));
            }

            //如果还没有生成单号 则默认最新时间为：1990-01-01
            if (null == creatTime)
                creatTime = format.parse("1900-01-01");

            String newDate = format.format(creatTime);
            String[] times = time.split("-");
            String day = times[0].substring(2);
            result.append(identify).append(day).append(times[1]).append(times[2]);
            String serialNum = "001";
            if (time.equals(newDate)) {
                String serialNumber = billNo.substring(index);
                result = serialNumSelfAdd(result, serialNumber);

            } else {
                result.append(serialNum);
            }
        } catch (ParseException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        }
        return result.toString();
    }

    /**
     * 处理导出数据
     *
     * @param cols
     * @param list
     * @param <T>
     * @return
     */
    public static <T> List<LinkedHashMap<String, Object>> dealExportDataClass(String[] cols, List<T> list) {
        List<LinkedHashMap<String, Object>> result = new ArrayList<>();

        if (null != list && null != cols && cols.length > 0) {
            list.forEach(t -> {
                LinkedHashMap<String, Object> item = new LinkedHashMap<>();
                for (String col : cols) {
                    try {
                        Object obj = getFieldValue(t, col);
                        Field field = ((T) t).getClass().getDeclaredField(col);
                        Annotation annotation = field.getAnnotation(NumberFormat.class);
                        if (null != annotation) {
                            Method method = annotation.annotationType().getMethod(PERCENT);
                            if (null != method) {
                                boolean percent = (Boolean) method.invoke(annotation, null);
                                if (percent) {
                                    StringBuffer val = new StringBuffer();
                                    if (null != obj) {
                                        val.append(obj).append("%");
                                        obj = val.toString();
                                    }
                                }
                            }
                        }
                        item.put(col, obj);
                    } catch (NoSuchFieldException e) {
                        e.printStackTrace();
                    } catch (IllegalAccessException e) {
                        e.printStackTrace();
                    } catch (InvocationTargetException e) {
                        e.printStackTrace();
                    } catch (NoSuchMethodException e) {
                        e.printStackTrace();
                    }
                }
                result.add(item);
            });
        }
        return result;
    }

    /**
     * 处理导出数据
     *
     * @param cols
     * @param list
     * @return
     */
    public static List<LinkedHashMap<String, Object>> dealExportDataMap(String[] cols, List<LinkedHashMap<String, Object>> list) {
        List<LinkedHashMap<String, Object>> result = new ArrayList<>();

        if (null != list && list.size() > 0 && null != cols && cols.length > 0) {
            list.forEach(map -> {
                LinkedHashMap<String, Object> item = new LinkedHashMap<>();
                for (String col : cols) {
                    Object obj = map.get(col);
                    item.put(col, obj);
                }
                result.add(item);
            });
        }
        return result;
    }

    /**
     * 获取类字段数据
     *
     * @param t
     * @param fieldName
     * @return
     * @throws NoSuchFieldException
     */
    public static <T> Object getFieldValue(T t, String fieldName) {
        Field field;
        try {
            field = ((T) t).getClass().getDeclaredField(fieldName);
            field.setAccessible(true);
            try {
                Object o = field.get(t);
                return o;
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 为某个字段设置值
     *
     * @param t
     * @param obj
     * @param fieldName
     * @param <T>
     */
    public static <T> void setValueToField(T t, Object obj, String fieldName) {
        Field field;
        try {
            field = ((T) t).getClass().getDeclaredField(fieldName);
            field.setAccessible(true);
            field.set(t, obj);
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
    }
}
