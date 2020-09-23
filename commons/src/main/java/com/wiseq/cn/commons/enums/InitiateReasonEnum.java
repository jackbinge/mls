package com.wiseq.cn.commons.enums;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/5/22     jiangbailing      原始版本
 * 文件说明:发起流程的原因
 */
public enum InitiateReasonEnum {
    MAIN(0,"此为主流程"),
    POWDER_CHANGE(1,"荧光粉批次变更"),
    MATERIAL_NOT_ENOUGH(2,"在制物料库存不足"),
    ASSES_NEW_MATERIAL(3,"评估新物料");

    private int flag;
    private String content;

    InitiateReasonEnum(int flag, String content) {
        this.flag = flag;
        this.content = content;
    }

    public int getFlag() {
        return flag;
    }

    public String getContent() {
        return content;
    }

    public static InitiateReasonEnum reasonOf(int index) {
        for (InitiateReasonEnum reason : values()) {
            if (reason.flag == index) {
                return reason;
            }
        }
        return null;
    }
}
