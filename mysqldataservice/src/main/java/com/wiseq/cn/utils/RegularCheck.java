package com.wiseq.cn.utils;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/8     lipeng      原始版本
 * 文件说明:
 */
public class RegularCheck {
    /**
     * 2.2.2.3
     * @param str
     * @return
     */
    public static Boolean RegexMatches(String str) {
//        String pattern = "1 1.2 2.3 3.4 4 4";
        Pattern r = Pattern.compile(str);
        Matcher m = r.matcher(str);
        if(m.matches()){
            return true;
        }
        else {
            return false;
        }
    }

    public static Boolean RegexMatchesl(String str) {
//        String str = "";
//        String pattern = "1 1.2 2.3 3.4 4";

        Pattern r = Pattern.compile(str);
        Matcher m = r.matcher(str);
        if(m.matches()){
            return true;
        }
        else {
            return false;
        }
    }
}
