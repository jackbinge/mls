package com.wiseq.cn.commons.enums;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/16     jiangbailing      原始版本
 * 文件说明:
 */
public enum BomSourceEnum {
    EAS(0,"EAS投料"),
    UserEdit(1,"人工建立"),
    SystemRecommed(2,"系统推荐");



    private Integer sourceFlag;
    private String sourceName;

    BomSourceEnum(Integer stateFlag, String stateName) {
        this.sourceFlag = stateFlag;
        this.sourceName = stateName;
    }


    public Integer getStateFlag() {
        return sourceFlag;
    }

    public String getStateName() {
        return sourceName;
    }


    public static BomSourceEnum stateFlagOf(Integer index) {
        for (BomSourceEnum sourceFlag : values()) {
            if (sourceFlag.sourceFlag == index) {
                return sourceFlag;
            }
        }
        return null;
    }
}
