package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/9    lipeng      原始版本
 * 文件说明:  色区
 */
@Data
public class TColorRegionGroup {

    /**
     * 色区主表
     */
    private TColorRegion tColorRegion;

    /**
     * 色区详情
     */
    private TColorRegionDtl tColorRegionDtl;
}