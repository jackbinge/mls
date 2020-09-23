package com.wiseq.cn.commons.utils;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URLDecoder;
import java.net.URLEncoder;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: cookies utils
 **/
public class CookiesUtils {
    private static String cookiePrex = "quanshi_";

    /**
     * 创建cookies
     *
     * @param response    HttpServletResponse
     * @param cookieName  String
     * @param cookieValue String
     * @param maxAge 单位为秒
     */
    public static void createCookies(HttpServletResponse response,
                                     String cookieName,
                                     String cookieValue,
                                     int maxAge) {
        if (QuHelper.isNull(cookieName) || QuHelper.isNull(cookieValue) || !QuHelper.isNumeric(maxAge)) {
            return;
        }
        try {
            cookieValue = URLEncoder.encode(cookieValue, "UTF-8");
        } catch (Exception e) {
            e.printStackTrace();
        }
        Cookie cookie = new Cookie(cookiePrex + cookieName, cookieValue);
        cookie.setMaxAge(maxAge);
        cookie.setPath("/");
        response.addCookie(cookie);
    }

    /**
     * 创建cookies
     *
     * @param response    HttpServletResponse
     * @param cookieName  String
     * @param cookieValue String
     */
    public static void createCookies(HttpServletResponse response,
                                     String cookieName,
                                     String cookieValue) {
        createCookies(response, cookieName, cookieValue, 60 * 60 * 24);
    }

    /**
     * 写入cookie
     * @param cookieName
     * @param cookieValue
     */
    public static void createCookies( String cookieName,
                                      String cookieValue){
        ServletRequestAttributes req = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletResponse res = req.getResponse();
        createCookies(res,cookieName,cookieValue);
    }

    /**
     * 读取Cookie
     * @param cookieName
     * @return
     */
    public static String readCookies(String cookieName){
        if (QuHelper.isNull(cookieName)) {
            return "";
        }
        ServletRequestAttributes req = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = req.getRequest();

        return readCookies(request,cookieName);
    }
    /**
     * 读取Cookies
     *
     * @param request    HttpServletRequest
     * @param cookieName String
     * @return String
     */
    public static String readCookies(HttpServletRequest request, String cookieName) {
        if (QuHelper.isNull(cookieName)) {
            return "";
        }

        Cookie[] cookie = request.getCookies();

        if (cookie == null) {
            return "";
        }
        for (Cookie c : cookie) {

            if (c.getName().equals(cookiePrex + cookieName)) {
                String cv = c.getValue().toString();
                try {
                    cv = URLDecoder.decode(cv, "UTF-8");
                } catch (Exception e) {
                    e.printStackTrace();
                }
                return cv;
            }
        }
        return "";
        //return "admin";
    }

    /**
     * 删除Cookies
     *
     * @param request    HttpServletRequest
     * @param response   HttpServletResponse
     * @param cookieName String
     */
    public static void removeCookies(HttpServletRequest request,
                                     HttpServletResponse response,
                                     String cookieName) {
        if (QuHelper.isNull(cookieName)) {
            return;
        }
        Cookie[] cookie = request.getCookies();
        if (cookie == null) {
            return;
        }
        for (Cookie c : cookie) {
            if (c.getName().equals(cookiePrex + cookieName)) {
                c.setValue("");
                c.setPath("/");
                c.setMaxAge(0);
                response.addCookie(c);
                break;
            }
        }
    }

    public static void removeCookies(String cookieName) {
        ServletRequestAttributes req = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = req.getRequest();
        HttpServletResponse res = req.getResponse();
        removeCookies(request,res,cookieName);
    }
    /**
     * 更新Cookies
     *
     * @param request     HttpServletRequest
     * @param response    HttpServletResponse
     * @param cookieName  String
     * @param cookieValue String
     * @param maxAge      int
     */
    public static void updateCookies(HttpServletRequest request,
                                     HttpServletResponse response,
                                     String cookieName,
                                     String cookieValue,
                                     int maxAge) {
        removeCookies(request, response, cookieName);
        createCookies(response, cookieName, cookieValue, maxAge);
    }

    /**
     * 更新cookies
     *
     * @param request     HttpServletRequest
     * @param response    HttpServletResponse
     * @param cookieName  String
     * @param cookieValue String
     */
    public static void updateCookies(HttpServletRequest request,
                                     HttpServletResponse response,
                                     String cookieName,
                                     String cookieValue) {
        removeCookies(request, response, cookieName);
        createCookies(response, cookieName, cookieValue);
    }

    /**
     * 前缀
     *
     * @return
     */
    public static String getCookiePrex() {
        return cookiePrex;
    }
}
