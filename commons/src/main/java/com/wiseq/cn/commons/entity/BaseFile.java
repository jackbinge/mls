package com.wiseq.cn.commons.entity;

import lombok.Data;

/**
 * 版本        修改时间        作者        修改内容
 * V1.0        ------        wangyh       原始版本
 * 文件说明: BaseFile
 **/
@Data
public class BaseFile {
    private String id;
    private String name;
    private String saveName;
    private String path;
    private String webPath;
    private String suffix;
    private String dataId;
}
