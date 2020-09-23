package com.wiseq.cn.commons.utils;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: Session Utils
 **/
public class SessionUtils {
    private static String cookiePrex = "quanshi_";

    /**
     * 创建session
     *
     * @param httpSession  HttpSession
     * @param sessionName  String
     * @param sessionValue String
     */
    public static void createSession(HttpSession httpSession, String sessionName, String sessionValue) {
        if (QuHelper.isNull(sessionName)) {
            return;
        }
        try {
            httpSession.setAttribute(cookiePrex + sessionName, sessionValue);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Create session
     *
     * @param sessionName
     * @param sessionValue
     */
    public static void createSession(String sessionName, String sessionValue) {
        ServletRequestAttributes req = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = req.getRequest();
        HttpSession httpsession = request.getSession();
        createSession(httpsession, sessionName, sessionValue);
    }

    /**
     * 读取session
     *
     * @param httpSession HttpSession
     * @param sessionName String
     * @return String
     */
    public static String readSession(HttpSession httpSession, String sessionName) {
        String sessionValue = "";
        if (QuHelper.isNull(sessionName)) {
            return "";
        }
        try {
            sessionValue = httpSession.getAttribute(cookiePrex + sessionName).toString();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return sessionValue;
    }

    /**
     * 读取session
     *
     * @param sessionName
     * @return
     */
    public static String readSession(String sessionName) {
        ServletRequestAttributes req = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = req.getRequest();
        HttpSession httpsession = request.getSession();
        return readSession(httpsession, sessionName);
    }


    /**
     * 注销session
     *
     * @param httpSession HttpSession
     * @param sessionName String
     */
    public static void removeSession(HttpSession httpSession, String sessionName) {
        if (QuHelper.isNull(sessionName)) {
            return;
        }
        try {
            httpSession.removeAttribute(sessionName);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 移除session
     *
     * @param sessionName
     */
    public static void removeSession(String sessionName) {
        ServletRequestAttributes req = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = req.getRequest();
        HttpSession httpsession = request.getSession();
        removeSession(httpsession, sessionName);
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
