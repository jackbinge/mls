package com.wiseq.cn.commons.enums;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/5/22     jiangbailing      原始版本
 * 文件说明: 工单类型
 */
public enum SystemTaskTypeEnum {
    MAIN_TASK(0,"EAS工单"),
    SAMPLE_TASK(1,"纯打样工单");

    private String content;
    private Integer flag;

    SystemTaskTypeEnum(int flag, String content) {
        this.flag = flag;
        this.content = content;
    }

    public int getFlag() {
        return flag;
    }

    public String getContent() {
        return content;
    }

    public static SystemTaskTypeEnum typeOf(int index) {
        for (SystemTaskTypeEnum type : values()) {
            if (type.flag == index) {
                return type;
            }
        }
        return null;
    }
}
