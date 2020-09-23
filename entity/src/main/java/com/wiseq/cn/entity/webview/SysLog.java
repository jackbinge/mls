package com.wiseq.cn.entity.webview;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

/**
 * 版本        修改时间        作者        修改内容
 * V1.0        ------        songlp       原始版本
 * 文件说明: 系统操作日志
 **/
@Getter
@Setter
public class SysLog {
    private Integer  id;
    private Integer userId;//操作用户id
    private String userName;//操作用户姓名
    private String url;//请求地址
    private String params;//请求参数
    private String ip;//ip地址
    private Date operateTime;//操作时间
    private String result;//操作返回结果

    @Override
    public String toString() {
        return "SysLog{" +
                ", userId=" + userId +
                ", userName='" + userName + '\'' +
                ", url='" + url + '\'' +
                ", params='" + params + '\'' +
                ", ip='" + ip + '\'' +
                ", operateTime=" + operateTime +
                ", result='" + result + '\'' +
                '}';
    }
}