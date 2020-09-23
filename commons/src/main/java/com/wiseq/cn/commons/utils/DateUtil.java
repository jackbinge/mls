package com.wiseq.cn.commons.utils;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------         wangyh     原始版本
 * 文件说明: 日期工具类
 **/
public class DateUtil {
	
	public final static String YYMMDD = "yyyy-MM-dd";
	public final static String YYMM = "yyyyMM";
	public final static String YY = "yyyy";
	public final static String MM = "MM";
	public final static String DD = "dd";
	public final static String YYMMDD_HHMMSS = "yyyy-MM-dd HH:mm:ss";
	public final static String YYMMDDC = "yyyy年MM月dd日";
	
	public final static String[] weekOfDays = {"星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"};    
	
	private static ThreadLocal<Map<String, DateFormat>> threadLocal = new ThreadLocal<>();
	
	public static void init(){
		Map<String,DateFormat> map = threadLocal.get();
		if(map == null){
			map = new HashMap<>();
			
			DateFormat ymdDf = new SimpleDateFormat(YYMMDD);
			DateFormat ymDf = new SimpleDateFormat(YYMM);
			DateFormat yDf = new SimpleDateFormat(YY);
			DateFormat mDf = new SimpleDateFormat(MM);
			DateFormat dDf = new SimpleDateFormat(DD);
			DateFormat ymdhmsDf = new SimpleDateFormat(YYMMDD_HHMMSS);
			DateFormat ymdcDF = new SimpleDateFormat(YYMMDDC);

			map.put("ymdDf", ymdDf);
			map.put("ymDf", ymDf);
			map.put("yDf", yDf);
			map.put("mDf", mDf);
			map.put("dDf", dDf);
			map.put("ymdhmsDf", ymdhmsDf);
			map.put("ymdcDF", ymdcDF);
			
			threadLocal.set(map);
		}
	}
	
	public static DateFormat getDfByKey(String key){
		init();
		return threadLocal.get().get(key);
	}
	
	/**
	 * 私有构造函数，不允许创建DateUtil实例
	 */
	private DateUtil(){
		
	}
	
	/**
	 * 格式化时间
	 * @return
	 */
	public static String formateTime(Date date){
		return getDfByKey("ymdhmsDf").format(date);
	}
	
	/**
	 * 格式化时间
	 * @return
	 */
	public static String formateYYMM(Date date){
		return getDfByKey("ymDf").format(date);
	}
	
	/**
	 * 格式化日期
	 * @return
	 */
	public static String formateDate(Date date){
		return getDfByKey("ymdDf").format(date);
	}
	
	/**
	 * 当前日期
	 * @return
	 */
	public static String nowDateTime(){
		return getDfByKey("ymdhmsDf").format(new Date());
	}
	
	/**
	 * 当前月
	 * @return
	 */
	public static String nowMonth(){
		return getDfByKey("mDf").format(new Date());
	}

	/**
	 * 当前天
	 * @return
	 */
	public static String nowDay(){
		return getDfByKey("dDf").format(new Date());
	}

	/**
	 * 当前年份
	 * @return
	 */
	public static String nowYear(){
		return getDfByKey("yDf").format(new Date());
	}
	
	/**
	 * 当前时间(中文格式)
	 * @return
	 */
	public static String nowDateChinese(){
		return getDfByKey("ymdcDF").format(new Date());
	}
	
	/**
	 * 当前时间
	 * @return
	 */
	public static String nowDate(){
		return getDfByKey("ymdDf").format(new Date());
	}
	
	/**
	 * 获取当前时间-日期类型
	 * @return
	 */
	public static Date nowDateAsDate(){
		try {
			return getDfByKey("ymdDf").parse(nowDate());
		} catch (ParseException e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * 获取当前时间-时间类型
	 * @return
	 */
	public static Date nowDateAsTime(){
		try {
			return getDfByKey("ymdhmsDf").parse(nowDateTime());
		} catch (ParseException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * 格式化时间
	 * @return
	 */
	public static Date parseDateTime(String date){
		try {
			return getDfByKey("ymdhmsDf").parse(date);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 格式化日期
	 * @return
	 */
	public static Date parseDate(String date){
		try {
			return getDfByKey("ymdDf").parse(date);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 获取当前时间获取周几
	 * @return
	 */
	public static String getWeeksDay(Date date){  
		Calendar calendar = Calendar.getInstance();
		if (date != null) {
			calendar.setTime(date);
		}
		int w = calendar.get(Calendar.DAY_OF_WEEK) - 1;
		if (w < 0) {
			w = 0;
		}
		return weekOfDays[w];  
    }

	/**
	 * 日期格式转换("2019/08/26 4:25  -> 2019-08-26 04:25")
	 * @param time
	 * @return
	 */
	public static String parseTime(String time){
		if(time.contains("/")) {
			String[] time1 = time.split(" ");
			String[] time2 = time1[0].split("/");
			String[] time3 = time1[1].split(":");
			String day = String.format("%02d", Integer.valueOf(time2[1]));
			String tim = String.format("%02d", Integer.valueOf(time2[2]));
			String hour = String.format("%02d", Integer.valueOf(time3[0].trim()));
			String min = String.format("%02d", Integer.valueOf(time3[1].trim()));
			return time2[0] + "-" + day + "-" + tim + " " + hour + ":" + min;
		}
		return time;
	}

	/**
	 * 获取指定年月的每一天
	 * @param year
	 * @param month
	 * @return
	 */
	public static List<String> loadEveryDayByMonth(String year, String month){
		List<String> list = new ArrayList<>();
		Calendar calendar = Calendar.getInstance();
		calendar.clear();
		calendar.set(Integer.valueOf(year), Integer.valueOf(month)-1, 1);
		int lastDay = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
		for(int i=1; i<=lastDay; i++){
			list.add(month + "月" + String.format("%02d",i) + "日");
		}
		return list;
	}
}
