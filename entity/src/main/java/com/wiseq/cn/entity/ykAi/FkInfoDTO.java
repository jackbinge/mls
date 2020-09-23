package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/7/31     jiangbailing      原始版本
 * 文件说明: 方形
 */
@Data
public class FkInfoDTO  {

    private Long id;
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
