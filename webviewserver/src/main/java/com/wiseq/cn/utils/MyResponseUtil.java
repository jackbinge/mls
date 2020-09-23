package com.wiseq.cn.utils;



import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/19     jiangbailing      原始版本
 * 文件说明: response工具
 */
public class MyResponseUtil {
    public static final Logger log = LoggerFactory.getLogger(MyResponseUtil.class);
    /**
     * 以JSON格式输出
     * @param response
     */
    public   static void responseOutWithJson(HttpServletResponse response,
                                               Object responseObject) {
        //将实体对象转换为JSON Object转换
        JSONObject responseJSONObject = (JSONObject) JSON.toJSON(responseObject);
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=utf-8");
        PrintWriter out = null;
        try {
            out = response.getWriter();
            out.append(responseJSONObject.toString());
            log.debug("返回是\n");
            log.debug(responseJSONObject.toString());
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (out != null) {
                out.close();
            }
        }
    }
}
