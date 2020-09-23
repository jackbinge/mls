package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/6      jiangbailing      原始版本
 * 文件说明:基础库-机种库-出货要求色容差/色块中心点类型
 */
@Data
public class TOutPutRequirementsColorRegion {
    /**
     *色容差/色块系列
     */
    private String name;
    /**
     *色块系列或色容差ID
     */
    private Long id;
    /**
     *出货要求中心点
     */
    private Double cpX;
    /**
     *出货要求中心点
     */
    private Double cpY;
}
