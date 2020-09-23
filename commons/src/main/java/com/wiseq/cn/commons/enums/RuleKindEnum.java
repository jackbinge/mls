package com.wiseq.cn.commons.enums;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/29     jiangbailing      原始版本
 * 文件说明: 规则类型
 */
public enum RuleKindEnum {
    Ellipse((byte)0,"椭圆"),
    Quadrilateral((byte)1,"四边形"),
    Point((byte)2,"点"),
    OuputRatio((byte)3,"出货比例");
    private Byte   state;
    private String ruleName;

    RuleKindEnum(Byte state,String ruleName){
        this.state = state;
        this.ruleName = ruleName;
    }
    public Byte getState() {
        return state;
    }

    public String getRuleName() {
        return ruleName;
    }
}
