package com.wiseq.cn.entity.webview;

import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明:  错误信息入库Entity
 **/
@Setter
@Getter
public class ErrorMsg {
    private Long id;
    //所在服务名称
    private String servicename;
    //发生位置
    private String source;
    //错误编号
    private String code;
    //错误详细信息
    private String message;
    //发生时间
    private Timestamp createTime;

}
