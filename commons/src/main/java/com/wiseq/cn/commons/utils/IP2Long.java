package com.wiseq.cn.commons.utils;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: IP工具类
 **/
public class IP2Long {
    /**
     * 将127.0.0.1 形式的IP地址转换成10进制整数，这里没有进行任何错误处理
     * @param strIP IP
     * @return long
     */
    public static long ipToLong(String strIP){
        long[] ip=new long[4];
        //先找到IP地址字符串中.的位置
        int position1=strIP.indexOf(".");
        int position2=strIP.indexOf(".",position1+1);
        int position3=strIP.indexOf(".",position2+1);
        //将每个.之间的字符串转换成整型
        ip[0]=Long.parseLong(strIP.substring(0,position1));
        ip[1]=Long.parseLong(strIP.substring(position1+1,position2));
        ip[2]=Long.parseLong(strIP.substring(position2+1,position3));
        ip[3]=Long.parseLong(strIP.substring(position3+1));
        return (ip[0]<<24)+(ip[1]<<16)+(ip[2]<<8)+ip[3];
    }

    /**
     * 将10进制整数形式转换成127.0.0.1形式的IP地址
     * @param longIP long longIP
     * @return IP
     */
    public static String longToIP(long longIP){
        StringBuffer sb=new StringBuffer("");
        //直接右移24位
        sb.append(String.valueOf(longIP>>>24));
        sb.append(".");
        //将高8位置0，然后右移16位
        sb.append(String.valueOf((longIP&0x00FFFFFF)>>>16));
        sb.append(".");
        sb.append(String.valueOf((longIP&0x0000FFFF)>>>8));
        sb.append(".");
        sb.append(String.valueOf(longIP&0x000000FF));
        return sb.toString();
    }

    /**
     * 验证当前字符串是否是正确的ip地址
     *
     * @param ip
     * @return
     */
    public static Boolean ipCheck(String ip) {
        if (QuHelper.isNull(ip)) {
            return false;
        }
        // 定义正则表达式
        String regex = "^(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|[1-9])\\."
                + "(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\."
                + "(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\."
                + "(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)$";
        if (ip.matches(regex)) {
            return true;
        }
        return false;
    }


    public static  String getIpAddr() {
        ServletRequestAttributes req = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = req.getRequest();
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
}
