package com.wiseq.cn.entity.webview;

import lombok.Getter;
import lombok.Setter;

/**
 * 版本        修改时间        作者        修改内容
 * V1.0        ------        wangyanhui   原始版本
 * 文件说明: OEE
 **/
@Setter
@Getter
public class OEEResult {
    private String eqptName;
    private String materialName;
    private String mouldWmsCode;
    private String dataTime;
    private String daNum;
    private double beatRate;
    private double oeeRate;
}
