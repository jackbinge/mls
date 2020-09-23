package com.wiseq.cn.commons.utils;

import com.wiseq.cn.commons.entity.Merge;
import net.sf.cglib.beans.BeanMap;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

/**
 * 版本        修改时间        作者        修改内容
 * V1.0        ------        wangyh       原始版本
 * 文件说明: CommonsUtil
 **/
public class CommonsUtil {
    /**
     * 计算总体标准偏差
     * @param list
     * @return
     */
    public static Double loadSTDEV(List<Double> list){
        if(list.size() > 0){
            Double avg = list.stream().mapToDouble((map)->map).average().getAsDouble();
            AtomicInteger index = new AtomicInteger(1);
            Double result = list.stream().map((cost) -> cost - avg).reduce((sum, cost) -> {
                if(index.get() == 1) sum = Math.pow(sum,2);
                index.addAndGet(1);
                return sum + Math.pow(cost,2);
            }).map((cost) -> Math.sqrt(cost/list.size())).get();
            return Double.valueOf(String.format("%.2f", result));
        }
        return null;
    }

    /**
     * 根据属性获取对象值
     */
    public static Object getFieldValueByName(String fieldName, Object o) {
        try {
            String firstLetter = fieldName.substring(0, 1).toUpperCase();
            String getter = "get" + firstLetter + fieldName.substring(1);
            Method method = o.getClass().getMethod(getter, new Class[] {});
            Object value = method.invoke(o, new Object[] {});
            return value;
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 判断属性是不是合法
     */
    public static Boolean fieldIsInObject(Class calss,String fieldName) {
        try {
            String firstLetter = fieldName.substring(0, 1).toUpperCase();
            String getter = "get" + firstLetter + fieldName.substring(1);
            Method method = calss.getMethod(getter, new Class[] {});
            if(method!=null){
                return true;
            }
        } catch (Exception e) {
            return false;
        }
        return false;
    }

    /**
     * 字符串转Ascii
     * @param str
     * @return
     */
    public static String strToAscii(String str) {
        if (str == null) {
            return "";
        }
        StringBuilder result = new StringBuilder("");
        for (int i = 0; i < str.length(); i++) {
            char tmp = str.charAt(i);
            int ascii = (int) tmp;
            if (i < (str.length() - 1)) {
                result.append(ascii);
            } else {
                result.append(ascii);
            }
        }
        return result.toString();
    }

    /**
     * //数字转字母 1-26 ： A-Z
     */
    public static String numberToLetter(int num) {
        if (num <= 0) {
            return null;
        }
        String letter = "";
        num--;
        do {
            if (letter.length() > 0) {
                num--;
            }
            letter = ((char) (num % 26 + (int) 'A')) + letter;
            num = (int) ((num - num % 26) / 26);
        } while (num > 0);

        return letter;
    }

    /**
     * 将对象集合转为Map集合
     * @param objList
     * @param <T>
     * @return
     */
    public static <T> List<LinkedHashMap<String,Object>> objectsToMaps(List<T> objList){
        List<LinkedHashMap<String,Object>> list = new ArrayList<>();
        if(objList != null && objList.size() > 0){
            LinkedHashMap<String,Object> map;
            for(T obj : objList){
                map = beanToMap(obj);
                list.add(map);
            }
        }
        return list;
    }

    /**
     * 将对象转为Map
     * @param bean
     * @param <T>
     * @return
     */
    public static <T> LinkedHashMap<String,Object> beanToMap(T bean){
        LinkedHashMap<String,Object> map = new LinkedHashMap<>();
        if(bean != null){
            BeanMap beanMap = BeanMap.create(bean);
            for(Object key : beanMap.keySet()){
                map.put(key + "", beanMap.get(key));
            }
        }
        return map;
    }

    /**
     * 解析数据
     * @param mapList
     * @param days
     * @param columns
     * @return
     */
    public static LinkedHashMap<String, Object> parseData(List<LinkedHashMap<String, Object>> mapList, List<String> days, int columns){
        List<LinkedHashMap<String, Object>> newList = new ArrayList<>();
        AtomicInteger index = new AtomicInteger(0);
        AtomicReference<String> lastDay = new AtomicReference<>("");
        LinkedHashMap<String, Merge> mergeMap = new LinkedHashMap<>();
        AtomicInteger row = new AtomicInteger(1);
        mapList.stream().forEach(detail -> {
            for(int i=index.get(); i<days.size(); i++){
                row.addAndGet(1);
                if(days.get(i).equals(detail.get("checkDate"))){
                    if(!mergeMap.containsKey(days.get(i))){
                        Merge merge = new Merge();
                        merge.setFirstCol(0);
                        merge.setLastCol(0);
                        merge.setFirstRow(row.get());
                        mergeMap.put(days.get(i), merge);
                    }
                    newList.add(detail);
                    index.set(i);
                    lastDay.set(days.get(i));
                    mergeMap.get(days.get(i)).setLastRow(row.get());
                    break;
                }else {
                    if(days.get(i).equals(lastDay.get())){
                        mergeMap.get(days.get(i)).setLastRow(row.get()-1);
                        row.set(row.get() - 1);
                        continue;
                    }
                    newList.add(perch(days.get(i), columns));
                    index.set(i+1);
                }
            }
        });
        // 剩余数据补充
        if(index.get() + 1 != days.size()){
            mergeMap.get(days.get(index.get())).setLastRow(row.get());
            for(int i=index.get() + 1; i<days.size(); i++){
                newList.add(perch(days.get(i), columns));
            }
        }
        // 处理行合并
        List<Merge> margeList = new ArrayList<>();
        for(Map.Entry<String,Merge> entry:mergeMap.entrySet()){
            if(entry.getValue().getFirstRow() != null && entry.getValue().getLastRow() != null &&
                    entry.getValue().getFirstCol() != null && entry.getValue().getLastCol() != null &&
                    entry.getValue().getFirstRow() != entry.getValue().getLastRow()){
                margeList.add(entry.getValue());
            }
        }
        // 返回数据
        LinkedHashMap<String, Object> resultMap = new LinkedHashMap<>();
        resultMap.put("data", newList);
        resultMap.put("merge", margeList);
        return resultMap;
    }

    /**
     * 占位补空
     * @param checkDate
     * @return
     */
    private static LinkedHashMap<String,Object> perch(String checkDate, int columns){
        LinkedHashMap<String,Object> map = new LinkedHashMap<>();
        map.put("checkDate",checkDate);
        for(int i=0; i<columns; i++){
            map.put("param" + i, "");
        }
        return map;
    }
}
