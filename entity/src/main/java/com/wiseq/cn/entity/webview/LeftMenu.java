package com.wiseq.cn.entity.webview;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * 版本        修改时间        作者        修改内容
 * V1.0        ------        songlp       原始版本
 * 文件说明: LeftMenu
 **/
@Getter
@Setter
public class LeftMenu {
    private Integer id;
    private String path;
    private String name;
    private String redirect;
    private String component;
    //private String meta;
    private String funIds;
//    private String title;
//    private String icon;
    private Meta meta;
    private List<LeftMenu> children=new ArrayList<LeftMenu>();
}