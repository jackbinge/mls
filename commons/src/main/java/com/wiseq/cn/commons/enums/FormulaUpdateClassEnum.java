package com.wiseq.cn.commons.enums;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/12/5     jiangbailing      原始版本
 * 文件说明:1系统推荐，2用户编辑，3生产修正
 */
public enum  FormulaUpdateClassEnum {
    SysRecommend((byte)1,"系统推荐"),
    UserEdit((byte)2,"用户编辑"),
    ProductionCheck((byte)3,"生产修正");

    private Byte stateFlag;
    private String stateName;

    FormulaUpdateClassEnum(Byte stateFlag, String stateName) {
        this.stateFlag = stateFlag;
        this.stateName = stateName;
    }

    public Byte getStateFlag() {
        return stateFlag;
    }

    public String getStateName() {
        return stateName;
    }
}
