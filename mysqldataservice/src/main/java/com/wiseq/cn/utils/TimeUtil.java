package com.wiseq.cn.utils;

import org.apache.commons.lang.StringUtils;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/7/12 10:03  molei      原始版本
 * 文件说明: TODO
 **/
public class TimeUtil {
    /**
     * 两个时间之间的相差天、时、分
     *
     * @param startTime
     * @param endTime
     * @return
     */
    public static String getTimefromTwo(String startTime, String endTime) {
        if (StringUtils.isEmpty(startTime) || StringUtils.isEmpty(endTime)) return "0";
        String fmt = "yyyy-MM-dd hh:mm";
        SimpleDateFormat sdf = new SimpleDateFormat(fmt);
        Long total = 0L;
        try {
            Date startDate = sdf.parse(startTime);
            System.out.println(startDate);
            Date endDate = sdf.parse(endTime);
            System.out.println(endDate);
            total = endDate.getTime() - startDate.getTime();
            System.out.println(total);
        } catch (Exception e) {
            e.printStackTrace();
        }

        long day = total / (60 * 60 * 1000 * 24);
        long hour = (total - day * 60 * 60 * 1000 * 24) / (60 * 60 * 1000);
        long minute = (total - day * 60 * 60 * 1000 * 24 - hour * 60 * 60 * 1000) / (60 * 1000);

        String result = day + "天" + hour + "时" + minute + "分 ";
        return result;
    }

    /**
     * 获取当前日期是星期几
     *
     * @return
     */
    public static String getWeekDay() {
        String[] weekDays = new String[]{"周日", "周一", "周二", "周三", "周四", "周五", "周六"};
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        int weekDay = calendar.get(calendar.DAY_OF_WEEK) - 1;
        return weekDays[weekDay];
    }
}
