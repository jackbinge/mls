package com.wiseq.cn.commons.utils;

/**
 * @ClassName RadomThree
 * @Description TODO
 * @Author silver
 * @Date 2018/11/2 9:50
 * @Version 1.0
 **/

public class RadomThree {
    public static String getThreeLetter(){
        int S_1=(int)((Math.random())*26)+97;
        int S_2=(int)((Math.random())*26)+97;
        int S_3=(int)((Math.random())*26)+97;
        char a=(char) S_1;
        char b=(char) S_2;
        char c=(char) S_3;
        String result=String.valueOf(a)+String.valueOf(b)+String.valueOf(c);
        return result;
    }
    public static String getThreeNumber(){
        int S_1=(int)((Math.random())*10);
        int S_2=(int)((Math.random())*10);
        int S_3=(int)((Math.random())*10);
        String result=String.valueOf(S_1)+String.valueOf(S_2)+String.valueOf(S_3);
        return result;
    }
}
