package com.wiseq.cn.commons.utils;

import com.opencsv.CSVReader;

import java.io.FileInputStream;
import java.io.FileReader;
import java.io.DataInputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Field;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * 版本        修改时间        作者        修改内容
 * V1.0        ------        wangyh       原始版本
 * 文件说明: CvsUtil
 **/
public class CsvUtil {
    /**
     * 读取Csv文件
     * @param clas   目标对象
     * @param path   文件路径
     * @param startTag  表头行标记
     * @return
     */
    public static List<Object> read(Class clas, String path, String startTag){
        try {
            DataInputStream in = new DataInputStream(new FileInputStream(path));
            CSVReader reader = new CSVReader(new InputStreamReader(in,"gbk"));
            String [] nextLine;
            boolean start = false;
            List<String> headList = new ArrayList<>();
            List<Object> dataList = new ArrayList<>();
            while((nextLine = reader.readNext()) != null) {
                if(start){
                    Object obj = clas.newInstance();
                    Field[] userFields = clas.getDeclaredFields();
                    for (int i = 0; i <userFields.length ; i++) {
                        // AccessibleTest类中的成员变量为private,故必须进行此操作
                        // 取消属性的访问权限控制，即使private属性也可以进行访问。
                        userFields[i].setAccessible(true);
                        // 将指定对象变量上此Field对象表示的字段设置为指定的新值。
                        String type = userFields[i].getGenericType().toString();
                        Integer index = headList.indexOf(userFields[i].getName().toLowerCase());
                        // 属性不存在跳过
                        if(-1 == index) continue;
                        if(index >= nextLine.length) break;
                        String value = nextLine[index];
                        // 判断属性类型
                        if ("class java.lang.String".equals(type)) {
                            // 如果type是类类型，则前面包含"class "，后面跟类名
                            userFields[i].set(obj,value);
                        }else if ("class java.lang.Integer".equals(type)) {
                            userFields[i].set(obj,Integer.valueOf(!QuHelper.isNumber(value)?"0":value));
                        }else if ("class java.lang.Double".equals(type)) {
                            userFields[i].set(obj,Double.valueOf(!QuHelper.isNumber(value)?"0":value));
                        }
                    }
                    dataList.add(obj);
                }
                // 数据头部开始标记
                if(nextLine[0].equals(startTag)) {
                    start = true;
                    Arrays.asList(nextLine).stream().forEach(column -> headList.add(column.toLowerCase()));
                }
            }
            return dataList;
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 读取Csv文件
     * @param path   文件路径
     * @return
     */
    public static CSVReader read(String path){
        try {
             return new CSVReader(new FileReader(path));
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }
}
