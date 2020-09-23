package com.wiseq.cn.commons.utils;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: 业务类工具类，提供涉及业务的方法
 **/
public class BuinessUtils {

    /**
     * 是否是合格用户名
     *
     * @param username
     * @return
     */
    public static Boolean isUserName(String username) {
        if (QuHelper.isNull(username)) {
            return false;
        }
        if (username.trim().length() < 3) {
            return false;
        }
        if(!QuHelper.isNumericOrLetter(username)){
            return false;
        }
        return true;
    }

    /**
     * 是否是合法的角色名
     * @param roleName
     * @return
     */
    public static Boolean isRoleName(String roleName){
        if(QuHelper.isNull(roleName)){
            return false;
        }
        if(roleName.trim().length() > 100){
            return false;
        }
        return true;
    }

    /**
     * 是否是合法的中文角色名
     * @param roleCName
     * @return
     */
    public static Boolean isRoleCName(String roleCName){
        if(QuHelper.isNull(roleCName)){
            return false;
        }
        if(roleCName.trim().length() > 100){
            return false;
        }
        return true;
    }

    /**
     * 是否是合格密码
     *
     * @param password
     * @return
     */
    public static Boolean isPassword(String password) {
        if (QuHelper.isNull(password)) {
            return false;
        }
        if (password.trim().length() < 6 || password.trim().length() > 20) {
            return false;
        }
        return true;
    }

    /**
     * 是否是合格的设备编号
     *
     * @param code
     * @return
     */
    public static Boolean isDeviceCode(String code) {
        if (QuHelper.isNull(code)) {
            return false;
        }
        if (code.trim().length() < 3) {
            return false;
        }
        return true;
    }

    /**
     * 是否是合格的工厂编号
     *
     * @param code
     * @return
     */
    public static Boolean isFactoryCode(String code) {
        if (QuHelper.isNull(code)) {
            return false;
        }
        if (code.trim().length() < 3) {
            return false;
        }
        return true;
    }

    /**
     * 是否是合格的部门编号
     *
     * @param code
     * @return
     */
    public static Boolean isDepartmentCode(String code) {
        if (QuHelper.isNull(code)) {
            return false;
        }
        if (code.trim().length() < 3) {
            return false;
        }
        return true;
    }
}
