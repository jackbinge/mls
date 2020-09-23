package com.wiseq.cn.commons.utils;

import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.exception.QuException;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: 数据类型转换类
 **/
public class Convert {
    /**
     * 字符转Int
     *
     * @param s string
     * @return int
     * @throws QuException
     */
    public static int toInt(String s) throws QuException {
        if (!QuHelper.isNumeric(s)) {
            throw new QuException(ResultEnum.NUMBERIC_FORMAT_ERR);
        }
        return Integer.parseInt(s);
    }


    /**
     * 获得当前日期 yyyy-MM-dd
     *
     * @return string
     */
    public static String getToday() {
        String re = "";
        Date d = new Date();
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
        re = sf.format(d);
        return re;
    }

    /**
     * 获得当前时间 yyyy-MM-dd HH:mm:ss
     *
     * @return String
     */
    public static String getNow() {
        String re = "";
        Date d = new Date();
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        re = sf.format(d);
        return re;
    }

    /**
     * 获得短格式
     *
     * @param s String
     * @return 字符串
     * @throws QuException
     */
    public static String toDate(String s) throws QuException {

        try {
            s = s.replace("/", "-");
        } catch (Exception ex) {
            throw new QuException(ResultEnum.DATE_FORMAT_ERR);
        }
        String re = "";
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            re = sf.format(sf.parse(s));
        } catch (ParseException e) {
            throw new QuException(ResultEnum.DATE_FORMAT_ERR);
        }
        return re;
    }

    /**
     * 获得短格式
     *
     * @param s 字符串
     * @throws QuException
     */
    public static Date toDDate(String s) throws QuException {

        try {
            s = s.replace("/", "-");
        } catch (Exception ex) {
            throw new QuException(ResultEnum.DATE_FORMAT_ERR);
        }
        Date re = null;
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            re = sf.parse(sf.format(s));
        } catch (ParseException e) {
            throw new QuException(ResultEnum.DATE_FORMAT_ERR);
        }
        return re;
    }

    /**
     * 转换时间为长格式
     *
     * @param s String
     * @return String
     * @throws QuException
     */
    public static String toLongDate(String s) throws QuException {

        String re = "";
        SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        try {
            re = sf.format(sf.parse(s));
        } catch (Exception e) {
            throw new QuException(ResultEnum.DATE_FORMAT_ERR);
        }
        return re;
    }

    /**
     * 转换字符为日期
     *
     * @param s String
     * @return Date
     * @throws QuException
     */
    public static Date StrToDate(String s) throws QuException {

        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Date date = null;
        try {
            date = format.parse(s);
        } catch (Exception e) {
            throw new QuException(ResultEnum.DATE_FORMAT_ERR);
        }
        return date;
    }

    /**
     * 转换字符为长时间
     *
     * @param s String
     * @return date
     * @throws QuException
     */
    public static Date strToLongDate(String s) throws QuException {

        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        Date date = null;
        try {
            date = format.parse(s);
        } catch (Exception e) {
            throw new QuException(ResultEnum.DATE_FORMAT_ERR);
        }
        return date;
    }

    /**
     * 利用java.lang.Math类对数字进行四舍五入
     *
     * @param dou 待舍入的数字
     * @return long
     */
    public static long getTraRoundMath(double dou) {
        //Math.round方法采用首先将dou加上0.5，然后取下整数。
        //dou = 4.6, 首先dou加0.5成5.1，其下整数为5。四舍五入的结果就是5。
        return Math.round(dou);
    }

    /**
     * 对数字进行四舍五入
     *
     * @param dou 待舍入的数字
     * @return long
     */
    public static long getTraRound(double dou) {
        //四舍五入模式相当于BigDecimal.ROUND_HALF_UP模式
        return getIntRound(dou, BigDecimal.ROUND_HALF_UP);
    }

    /**
     * 要求舍入后返回整数类型，
     *
     * @param dou       待舍入的数字
     * @param roundmode 舍入模式
     * @return long
     */
    public static long getIntRound(double dou, int roundmode) {
        //	最后取得BigDecimal对象转化成int并返回。
        return getRound(dou, 0, roundmode).longValue();
    }

    /**
     * 要求舍入后返回BigDecimal类型
     *
     * @param dou       待舍入的数字
     * @param scale     返回的BigDecimal对象的标度（scale）
     * @param roundmode 舍入模式
     * @return BigDecimal
     */
    public static BigDecimal getRound(double dou, int scale, int roundmode) {
        //创建一个新的BigDecimal对象paramNumber，该对象的值和dou大小一样。
        BigDecimal paramNumber = new BigDecimal(dou);
        //然后调用paramNumber的setScale方法，该方法返回一个 BigDecimal对象temp，
        //返回值的标度为第一个参数指定的值，标度为大小表示小数部分的位数
        //第二个参数指定了paramNumber对象到temp对象的舍入模式，如四舍五入等。
        return paramNumber.setScale(scale, roundmode);
        //实际可以一条语句实现：return new BigDecimal(dou).setScale(0, roundmode);
    }

    /**
     * 转换成时间戳
     *
     * @param timestampStr String
     * @return Timestamp
     * @throws QuException
     */
    public static Timestamp toTimestamp(String timestampStr) throws QuException {
        if (timestampStr == null || "".equals(timestampStr.trim())) {
            return null;
        }
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        try {
            Date date = dateFormat.parse(timestampStr);
            return new Timestamp(date.getTime());
        } catch (Exception e) {
            throw new QuException(ResultEnum.TIMESTAMP_FORMAT_ERR);
        }
    }
}

