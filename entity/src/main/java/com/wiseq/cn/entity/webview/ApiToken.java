package com.wiseq.cn.entity.webview;

import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: Api Token entity
 **/
@Setter
@Getter
public class ApiToken {
    private Integer id;
    private String clientID;
    private String clientSecret;
    private String clientPassword;
}
