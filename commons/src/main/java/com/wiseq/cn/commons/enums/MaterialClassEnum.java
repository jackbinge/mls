package com.wiseq.cn.commons.enums;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/12/4     jiangbailing      原始版本
 * 文件说明: 物料类型
 */
public enum MaterialClassEnum {
    AGLue((byte) 0,"A胶"),
    BGLue((byte)1,"B胶"),
    TPhosphors((byte)2,"荧光粉"),
    antiStarchMaterial((byte)3,"坑沉淀粉"),
    diffusionPowderMaterial((byte)4,"扩散粉");


    private Byte stateFlag;
    private String stateName;

    MaterialClassEnum(Byte stateFlag, String stateName) {
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
