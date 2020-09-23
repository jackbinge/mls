package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/6/13     jiangbailing      原始版本
 * 文件说明: 工单修改配方 过滤bom组合需要的参数
 */
@Data
public class FilterBOMDataForPage {
    private Long taskStateId;
    private List<ChipIdAndNum> chipIdAndNumList;
}
