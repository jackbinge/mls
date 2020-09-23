package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/20     jiangbailing      原始版本
 * 文件说明: 算法返回分光解析结果
 */
@Data
public class AiSplittingLightFileParse {
    /**
     * xy 点坐标
      */
    private List<List<Double>> xy;

    /**
     * 显色指数
     */
    private List<Double> Ra;
    /**
     * CRI9显色指数9（目前不用）
     */
    private List<Double> CRI9;
    /**
     * 亮度
     */
    private List<Double> LM;
}
