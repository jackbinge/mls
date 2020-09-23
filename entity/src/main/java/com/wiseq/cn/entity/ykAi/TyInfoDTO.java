package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/7/31     jiangbailing      原始版本
 * 文件说明: 色区库椭圆数据修改
 */
@Data
public class TyInfoDTO {

    private Long id;
    /**
     * 此色块所属色区ID
     */
    private Long colorRegionId;

    private Double a;
    private Double b;
    private Double x;
    private Double y;
    private Double angle;
}
