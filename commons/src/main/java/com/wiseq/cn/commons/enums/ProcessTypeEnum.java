package com.wiseq.cn.commons.enums;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/5/22     jiangbailing      原始版本
 * 文件说明: 流程类型
 */
public enum ProcessTypeEnum {
    MAIN_PROCESS(0,"主流程"),
    SAMPLE_PROCESS(1,"打样流程");

    private String content;
    private Integer flag;


    ProcessTypeEnum(int flag, String content) {
        this.flag = flag;
        this.content = content;
    }

    public int getFlag() {
        return flag;
    }

    public String getContent() {
        return content;
    }

    public static ProcessTypeEnum typeOf(int index) {
        for (ProcessTypeEnum type : values()) {
            if (type.flag == index) {
                return type;
            }
        }
        return null;
    }
}
