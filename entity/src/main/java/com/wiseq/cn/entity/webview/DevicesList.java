package com.wiseq.cn.entity.webview;

import lombok.Getter;
import lombok.Setter;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: device entity
 **/
@Setter
@Getter
public class DevicesList {
    private Integer id;
    private String code;
    private String name;
    private String factorycode;
    private String toIP;
    private String toport;
    private Integer isdeleted;

}
