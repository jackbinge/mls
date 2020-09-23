package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/6/6     jiangbailing      原始版本
 * 文件说明: 荧光粉和波长
 */
@Data
public class PhosphorPeakWavelength {
    private String spec;
    private Double peakWavelength;
}
