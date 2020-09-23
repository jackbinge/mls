package com.wiseq.cn.utils;

import org.apache.tomcat.jni.File;
import org.apache.tomcat.util.http.fileupload.IOUtils;

import javax.servlet.http.HttpServletRequest;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

/**
 * 版本        修改时间        作者        修改内容
 * V1.0        ------        wangyh       原始版本
 * 文件说明: WebUtil
 **/
public class WebUtil {
    /**
     *  解析Request中的所有参数
     * @param request
     * @return
     */
    public static Map<String, Object> parseRequestParams(HttpServletRequest request){
        Map<String, Object> newMap = new HashMap<>();
        Map<String, String[]> map = request.getParameterMap();
        Set keSet = map.entrySet();
        for(Iterator itr = keSet.iterator(); itr.hasNext();){
            Map.Entry me = (Map.Entry)itr.next();
            Object key = me.getKey();
            Object ov = me.getValue();
            String[] value;
            if(ov instanceof String[]){
                value = (String[])ov;
                newMap.put(key.toString(), value[0]);
            }else{
                newMap.put(key.toString(), ov.toString());
            }
        }
        // 移除流程KEY
        newMap.remove("processKey");
        newMap.remove("userId");
        return newMap;
    }

    public static void uploadLicense(FileInputStream inputStream){
        try{
            FileOutputStream fileOutputStream = new FileOutputStream("E:\\test.xlsx");
            IOUtils.copy(inputStream,fileOutputStream);
        }catch (Exception e){
            e.printStackTrace();
        }

    }

    public static void main(String[] args) {
        try{
            FileInputStream fileInputStream = new FileInputStream("F:\\LED\\before_test_file.csv");
            WebUtil.uploadLicense(fileInputStream);
        }catch (Exception e){
            e.printStackTrace();
        }

    }
}
