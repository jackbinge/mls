package com.wiseq.cn.service;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/12/3     jiangbailing      原始版本
 * 文件说明:
 */
public class UserOrder {

    /**
     * 拍摄主题
     */
    private String shootingTheme;
    /**
     * 摄影师
     */
    private String photographerName;
    /**
     * 设备编号
     */
    private String deviceCode;

    public UserOrder() {
    }

    public UserOrder(String shootingTheme, String photographerName, String deviceCode) {
        this.shootingTheme = shootingTheme;
        this.photographerName = photographerName;
        this.deviceCode = deviceCode;
    }

    @Override
    public String toString() {
        return "UserOrder{" +
                "shootingTheme='" + shootingTheme + '\'' +
                ", photographerName='" + photographerName + '\'' +
                ", deviceCode='" + deviceCode + '\'' +
                '}';
    }

    public String getShootingTheme() {
        return shootingTheme;
    }

    public void setShootingTheme(String shootingTheme) {
        this.shootingTheme = shootingTheme;
    }

    public String getPhotographerName() {
        return photographerName;
    }

    public void setPhotographerName(String photographerName) {
        this.photographerName = photographerName;
    }

    public String getDeviceCode() {
        return deviceCode;
    }

    public void setDeviceCode(String deviceCode) {
        this.deviceCode = deviceCode;
    }

}
