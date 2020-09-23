package com.wiseq.cn.commons.utils;

public class IQCUtil {
    /**
     * 来料检验管理的ID
     * @return
     */
    public static String getYrZlMaterialCheckID(){
        return "zlMC"+ID.get();
    }

    /**
     * 检测编号前缀
     * @return
     */
    public static String  checkNoSampleNoPrefix(){
        return  DateUtil.nowYear().substring(2,4)+DateUtil.nowMonth()+DateUtil.nowDay();
    }


    /**
     * IQC小批量试样
     * @return
     */
    public static String getYrZlSampleID(){
        return "zlSample"+ID.get();
    }

    /**
     *IQC初次试样
     * @return
     */
    public static String getYrZLFirstSampleID(){
        return "zlFSample"+ID.get();
    }


    /**
     * 初次试样前缀
     * @return
     */
    public static  String getFirstSampleNoPrefix(){
        return  "M-"+DateUtil.nowYear().substring(2,4)+DateUtil.nowMonth();
    }
}
