package com.wiseq.cn.commons.enums;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/5/22     jiangbailing      原始版本
 * 文件说明: 配比来源
 */
public enum RatioSourceEnum {
    RATIO_DATABASE(0,"配比数据库"),
    SYSTEM_RECOMMED(1,"系统推荐"),
    USER_EDIT(2,"用户编辑"),
    SOME_RECOMMEND(3,"打点推荐");

    private String content;
    private Integer flag;

    RatioSourceEnum(int flag, String content) {
        this.flag = flag;
        this.content = content;
    }

    public int getFlag() {
        return flag;
    }

    public String getContent() {
        return content;
    }

    public static RatioSourceEnum sourceOf(int index) {
        for (RatioSourceEnum source : values()) {
            if (source.flag == index) {
                return source;
            }
        }
        return null;
    }

}
