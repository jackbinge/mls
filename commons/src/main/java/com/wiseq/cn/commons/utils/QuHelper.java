package com.wiseq.cn.commons.utils;

import com.wiseq.cn.commons.exception.QuException;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: QuHelper
 **/
public class QuHelper {
    /**
     * 判断是否是空isNull(String s)
     *
     * @param s String
     * @return true or false
     */
    public static boolean isNull(String s) {
        if (s == null) {
            return true;
        }
        boolean bl = true;

        try {
            s = s.trim();
            bl = ("".equals(s) || s == null || s.isEmpty() || "null".equals(s)) ? true : false;

        } catch (Exception e) {
            e.printStackTrace();
            return true;
        }
        return bl;
    }

    /**
     * 判断是否是空isNull(int s)
     *
     * @param s int
     * @return true or false
     */
    public static boolean isNull(int s) {
        return isNull(s + "");
    }

    /**
     * 判断是否是空isNull(float s)
     *
     * @param s float
     * @return true or false
     */
    public static boolean isNull(float s) {
        return isNull(s + "");
    }

    /**
     * 判断是否是空isNull(double s)
     *
     * @param s double
     * @return true or false
     */
    public static boolean isNull(double s) {
        return isNull(s + "");
    }

    /**
     * 判断是否是空isNull(Integer s)
     *
     * @param s Integer
     * @return true or false
     */
    public static boolean isNull(Integer s) {
        try {
            String m = Integer.toString(s);
            return isNull(m);
        } catch (Exception e) {
            return true;
        }

    }

    /**
     * 判断是否是数字
     *
     * @param s string
     * @return true or false
     */
    public static boolean isNumeric(String s) {
        if (isNull(s)) {
            return false;
        }
        try {
            //Pattern pattern = Pattern.compile("^-?\\d+$");
            Pattern pattern = Pattern.compile("^-?[0-9]+$");
            Matcher isNum = pattern.matcher(s);
            if (!isNum.matches()) {
                return false;
            }
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 判断是否是数字
     *
     * @param i int
     * @return true or false
     */
    public static boolean isNumeric(int i) {
        String m = "";
        try {
            m = String.valueOf(i);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        if (isNull(m)) {
            return false;
        }
        return isNumeric(m);
    }

    //@Deprecated
    public static boolean isNumeric(Integer i) {
        if (i == null) {
            return false;
        }
        if (isNull(i)) {
            return false;
        }
        String m = String.valueOf(i);
        return isNumeric(m);
    }

    /**
     * @param i
     * @return
     */
    public static boolean isIntegerNull(Integer i) {
        if (i == null) {
            return false;
        }
        return true;
    }

    /**
     * String to Integer
     *
     * @param s
     * @return
     */
    public static Integer stringToInteger(String s) {
        if (!isNumeric(s)) {
            return null;
        }
        return Integer.valueOf(s);
    }

    /**
     * 是否是大约等于0的整数
     *
     * @param s string
     * @return true or false
     */
    public static Boolean isIntNumeric(String s) {
        if (isNull(s)) {
            return false;
        }
        Pattern pattern = Pattern.compile("[0-9]*");
        return pattern.matcher(s).matches();
    }

    /**
     * 将 Integer Null fill default value
     *
     * @param i        Integer
     * @param defaulti Integer
     * @return Integer
     */
    public static Integer toInteger(Integer i, Integer defaulti) {
        if (i == null) {
            return defaulti;
        }
        return i;
    }

    /**
     * Integer Null fill 0
     *
     * @param i Integer
     * @return Integer
     */
    public static Integer toInteger(Integer i) {
        return toInteger(i, 0);
    }

    /**
     * null fill string
     *
     * @param s
     * @param defaults
     * @return
     */
    public static String filltoString(String s, String defaults) {
        if (s == null) {
            return defaults;
        }
        return s;
    }

    /**
     * "" fill string
     *
     * @param s
     * @return
     */
    public static String filltoString(String s) {
        if (s == null) {
            return "";
        }
        return s;
    }

    /**
     * Timestamp fill if null
     *
     * @param ts
     * @return
     */
    public static Timestamp filltoTimestamp(Timestamp ts) {
        if (ts == null) {
            return getNowTime();
        }
        return ts;
    }


    /**
     * 比较两个字符串是否相同
     *
     * @param str1 字符一
     * @param str2 字符二
     * @return true or false
     */
    public static boolean isEquals(String str1, String str2) {
        boolean bl = false;
        if (isNull(str1) && isNull(str2)) {
            return true;
        }
        bl = str1.equals(str2);
        return bl;
    }

    /******
     * 获得当前的时间戳(Timestamp)
     *
     * @return Timestamp
     */
    public static Timestamp getNowTime() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String tsStr = sdf.format(new Date().getTime());
        Timestamp ts = new Timestamp(System.currentTimeMillis());
        try {
            ts = Timestamp.valueOf(tsStr);
            return ts;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ts;
    }

    /**
     * 获取当前时间(Time)
     *
     * @return String
     */
    public static String getCurrentTime() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(new Date().getTime());
    }


    /**
     * 时间戳转换成日期格式字符串
     *
     * @param seconds 精确到秒的字符串
     * @param format
     * @return
     */
    public static String timeStamp2Date(String seconds, String format) {
        if (seconds == null || seconds.isEmpty() || "null".equals(seconds)) {
            return "";
        }
        if (format == null || format.isEmpty()) {
            format = "yyyy-MM-dd HH:mm:ss";
        }
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        return sdf.format(new Date(Long.valueOf(seconds + "000")));
    }

    /**
     * 日期格式字符串转换成时间戳
     *
     * @param date_str 字符串日期
     * @param format   如：yyyy-MM-dd HH:mm:ss
     * @return
     */
    public static Timestamp date2TimeStamp(String date_str, String format) {
        if (isNull(date_str)) {
            return null;
        }
        Date re = null;
        SimpleDateFormat sf = new SimpleDateFormat(format);
        try {
            re = sf.parse(date_str);
            Timestamp ts = new Timestamp(re.getTime());
            return ts;
        } catch (ParseException e) {
            e.printStackTrace();
            return null;
        }

    }

    public static Timestamp date2TimeStamp(String date_str) {
        return date2TimeStamp(date_str, "yyyy-MM-dd HH:mm:ss");
    }

    /**
     * 取得当前时间戳（精确到秒）
     *
     * @return
     */
    public static String timeStamp() {
        long time = System.currentTimeMillis();
        String t = String.valueOf(time / 1000);
        return t;
    }

    /**
     * 延迟d分钟后的时间戳
     *
     * @param d int
     * @return 时间戳
     */
    public static Timestamp getTimeStamp(int d) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = new Date();
        Calendar calendar = new GregorianCalendar();
        calendar.setTime(date);
        calendar.add(Calendar.MINUTE, d);
        date = calendar.getTime();
        String tsStr = sdf.format(date);
        Timestamp ts = new Timestamp(System.currentTimeMillis());
        try {
            ts = Timestamp.valueOf(tsStr);
            return ts;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ts;
    }



    /**
     * 时间戳转换为Long
     *
     * @param ts 时间戳
     * @return Long
     */
    public static Long timpStampToLong(Timestamp ts) {
        return ts.getTime();
    }


    /**
     * 获取当前时间
     *
     * @return Date
     */
    public static Date getDateNow() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date re = null;
        try {
            re = sdf.parse(sdf.format(new Date()));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return re;
    }

    /**
     * 将时间转换为yyyy-MM-dd
     *
     * @param endDate
     * @return
     */
    public static String toDayDate(Date endDate) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(endDate);
    }

    /**
     * 获取当前日期(Date)
     *
     * @return String
     */
    public static String getCurrentDate() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(new Date());
    }

    public static String getCurrentDateTime() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        return sdf.format(new Date());
    }

    public static String getCurrentDateTimeNumber() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddhhmmss");
        return sdf.format(new Date());
    }

    public static String getRndNumber() {
        return getCurrentDateTimeNumber() + "" + getRnd(100, 999);
    }

    /**
     * 生成随机数 (a-b)
     *
     * @param a int
     * @param b int
     * @return String
     */
    public static String getRnd(int a, int b) {
        return (int) (Math.random() * (b - a)) + a + "";
    }

    /**
     * 获得当前Now(Time)
     *
     * @return String
     */
    public static String getNow() {
        Calendar c = Calendar.getInstance();
        int year = c.get(Calendar.YEAR);
        int month = c.get(Calendar.MONTH);
        int date = c.get(Calendar.DATE);
        int hour = c.get(Calendar.HOUR_OF_DAY);
        int minute = c.get(Calendar.MINUTE);
        int second = c.get(Calendar.SECOND);
        String n = year + "/" + month + "/" + date + " " + hour + ":" + minute + ":" + second;
        return n;
    }


    /**
     * 检测字符串中是否包含汉字
     *
     * @param s 字符
     * @return true or false
     */
    public static boolean ischeckChinese(String s) {
        if (isNull(s)) {
            return false;
        }
        final String format = "[\\u4E00-\\u9FA5\\uF900-\\uFA2D]";
        boolean result = false;
        Pattern pattern = Pattern.compile(format);
        Matcher matcher = pattern.matcher(s);
        result = matcher.find();
        return result;
    }

    /**
     * 只能是中文
     *
     * @param s
     * @return
     */
    public static boolean ischeckOnlyChinese(String s) {
        if (isNull(s)) {
            return false;
        }
        Pattern p = Pattern.compile("^[\\u4e00-\\u9fa5]+$");
        Matcher m = p.matcher(s);
        return m.matches();
    }

    /**
     * 数据对象比较是否相等
     *
     * @param a
     * @param b
     * @return
     */
    public static boolean isEqual(Number a, Number b) {
        if (null == a && null == b)
            return true;
        if ((null == a && null != b) || (null != a && null == b))
            return false;
        return a.equals(b);
    }

    /**
     * 只能是中文和英文,并且长度在1到20以内
     *
     * @param s
     * @return
     */
    public static boolean isOnlyChineseOrEnglish(String s) {
        Pattern p = Pattern.compile("^[\\u0391-\\uFFE5A-Za-z]{1,20}$");
        Matcher m = p.matcher(s);
        return m.matches();
    }

    /**
     * 校验字符串只能是数字,英文字母和中文
     *
     * @param s
     * @return boolean true or false
     */
    public static boolean isNumericOrString(String s) {
        Pattern p = Pattern.compile("^[\u4E00-\u9FA50-9a-zA-Z_-]{0,}$");
        Matcher m = p.matcher(s);
        return m.matches();
    }

    /**
     * 校验字符串只能是数字，和英文
     *
     * @param s
     * @return
     */
    public static boolean isNumericOrLetter(String s) {
        Pattern p = Pattern.compile("^[0-9a-zA_Z]+$");
        Matcher m = p.matcher(s);
        return m.matches();
    }

    public static void main(String[] args) {
        System.out.println(isNumericOrLetter("123"));
        System.out.println(ischeckOnlyChinese("我爱中华1"));
        System.out.println(isOnlyChineseOrEnglish(""));
        getAnyDayAddORSubAnyDay("2018-05-31", -160);
    }

    /**
     * 生成唯一的UUID
     *
     * @return String
     */
    public static String uuid() {
        String uid = UUID.randomUUID().toString().replace("-", "");
        return uid;
    }

    /**
     * 根据今天的日期创建目录
     *
     * @return string
     */
    public static String dateDir() {

        String path = getCurrentDate().replace("-", "_");
        return path;

    }

    /**
     * 获取当前日期加减一定天数后的日期
     *
     * @return
     */
    public static String getNowDayAddORSubDay(Integer day) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date dt = null;
        try {
            dt = sdf.parse(getCurrentDate());
        } catch (ParseException e) {
            e.printStackTrace();
        }
        Calendar rightNow = Calendar.getInstance();
        rightNow.setTime(dt);
        rightNow.add(Calendar.DAY_OF_YEAR, day);
        Date dt1 = rightNow.getTime();
        String reStr = sdf.format(dt1);
        System.out.println(reStr);
        return reStr;
    }

    /***
     * 是否为数字
     * @param string
     * @return
     */
    public static boolean isNumber(String string) {
        if (string == null)
            return false;
        Pattern pattern = Pattern.compile("^-?\\d+(\\.\\d+)?$");
        return pattern.matcher(string).matches();
    }

    public static String getAnyDayAddORSubAnyDay(String strDate, Integer day) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date dt = null;
        try {
            dt = sdf.parse(strDate);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        Calendar rightNow = Calendar.getInstance();
        rightNow.setTime(dt);
        //rightNow.add(Calendar.YEAR,-1);//日期减1年
        //rightNow.add(Calendar.MONTH,3);//日期加3个月
        rightNow.add(Calendar.DAY_OF_YEAR, day);//日期加10天
        Date dt1 = rightNow.getTime();
        String reStr = sdf.format(dt1);
        System.out.println(reStr);
        return reStr;
    }

}
