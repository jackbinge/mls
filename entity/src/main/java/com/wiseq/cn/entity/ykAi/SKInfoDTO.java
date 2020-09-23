package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/7/31     jiangbailing      原始版本
 * 文件说明:色块信息
 */
@Data
public class SKInfoDTO {

    private Long id;

    /**
     * 此色块所在行数, 只针对色块色区，色容差色区该字段为空
     */
    private int xrow;
    /**
     * 此色块所在列数，只针对色块色区，色容差色区该字段为空
     */
    private int xcolumn;
    /**
     * 此色块所属色区ID
     */
    private Long colorRegionId;

    private Double x1;
    private Double x2;
    private Double x3;
    private Double x4;
    private Double y1;
    private Double y2;
    private Double y3;
    private Double y4;
}
