package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/8     lipeng      原始版本
 * 文件说明: 原材料规则编辑构建
 */
@Data
public class MaterialTypeMapMix {

    private List<MaterialTypeMap> materialTypeMapListInsert;

    private List<MaterialTypeMap> materialTypeMapListUpdate;

    private List<MaterialTypeMap> materialTypeMapListDel;
}