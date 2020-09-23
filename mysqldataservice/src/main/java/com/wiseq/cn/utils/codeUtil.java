package com.wiseq.cn.utils;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        silver     原始版本
 * 文件说明: codeUtil
 **/

public class codeUtil {
    /**
     * @Author  silver
     * @Description // code自增
     * @Date 8:51 2018/10/9
     * @Param [codes]
     * @return java.lang.String
     **/
    public static String nextOfCode(List<String> codes){
        if (codes.size()==0){
            return "001";
        }
        int[] codesInt=new int[codes.size()];
        int i=0;
        for (String temp:codes){
            codesInt[i]=Integer.parseInt(temp);
        }
        int max=codesInt[0];
        for(int j=0;i<codesInt.length;i++)
        {
            if(codesInt[i]>max)
                max = codesInt[i];
        }
        int newcode=max+1;
        String codeString=newcode+"";
        String code="";
        switch (codeString.length()){
            case 1:
                code="00"+codeString;
                break;
            case 2:
                code="0"+codeString;
                break;
            case 3:
                code=codeString;
                break;
        }
        if (!"".equals(code)){
            return code;
        }else {
            return null;
        }

    }


    /**
     * 生成Code
     * @param typeName
     * @param id 当前
     * @return
     */
    public static  String getCode(String typeName,Integer id){
        return null;
    }

}


