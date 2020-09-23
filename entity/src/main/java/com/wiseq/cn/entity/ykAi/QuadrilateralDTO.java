package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;


/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/1/7     jiangbailing      原始版本
 * 文件说明: 四边形
 */
@Data
public class QuadrilateralDTO {

    private Long colorRegionId;

    private List<XYDTO> xydtoList;
}
