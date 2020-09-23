package com.wiseq.cn.commons.enums;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/18     jiangbailing      原始版本
 * 文件说明: 设备阀体状态枚举
 */
public enum EqptValveStateEnum {

    NOProduction(1l,"待生产"),
    INProduction(2l,"生产中"),
    ProductionNG(3l,"品质NG"),
    CLOSE(4l,"已关闭");

    private Long stateFlag;
    private String stateName;

    EqptValveStateEnum(Long stateFlag, String stateName) {
        this.stateFlag = stateFlag;
        this.stateName = stateName;
    }

    public Long getStateFlag() {
        return stateFlag;
    }

    public String getStateName() {
        return stateName;
    }
}
