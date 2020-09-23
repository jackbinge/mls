package com.wiseq.cn.entity.webview;

import lombok.Getter;
import lombok.Setter;

/**
 * 版本        修改时间        作者        修改内容
 * V1.0        ------        songlp       原始版本
 * 文件说明: Meta
 **/
@Getter
@Setter
public class Meta {
    private String title;
    private String icon;
    public Meta(String title,String icon){
        this.title=title;
        this.icon=icon;
    }
}