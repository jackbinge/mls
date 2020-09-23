package com.wiseq.cn.commons.enums;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: 系统异常，同样可以根据range自定义
 **/
public enum SystemEnum {
    DATABASE_ERR(-2,"数据库异常"),
    SYSTEM_ERR(-1,"系统错误"),
    NUMBERIC_FORMAT_ERR(1,"数字格式错误");
    private int state;
    private String stateInfo;

    SystemEnum(int state, String stateInfo) {
        this.state = state;
        this.stateInfo = stateInfo;
    }

    public int getState() {
        return state;
    }

    public String getStateInfo() {
        return stateInfo;
    }

    public static SystemEnum stateOf(int index) {
        for (SystemEnum state : values()) {
            if (state.state==index) {
                return state;
            }
        }
        return null;
    }
}
