package com.wiseq.cn.commons.entity;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

/**
 * 版本        修改时间        编者      备注
 * V1.0        ------        jpdong    原始版本
 * 文件说明:
 **/
@Setter
@Getter
public class WebResultParm {
    private String savePath;
    private String resultLabel;
    private Integer priority;
    private String labelInfo;
    private Integer sleepMs;

    // 业务扩展参数
    private String extParam;
}
