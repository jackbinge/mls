package com.wiseq.cn.commons.entity;

import lombok.Getter;
import lombok.Setter;

/**
 * 版本        修改时间        作者        修改内容
 * V1.0        ------        wangyh       原始版本
 * 文件说明: Merge
 **/
@Setter
@Getter
public class Merge {
    // 合并开始行
    private Integer firstRow;
    // 合并结束行
    private Integer lastRow;
    // 合并开始列
    private Integer firstCol;
    // 合并结束列
    private Integer lastCol;
}
