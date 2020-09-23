package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/20     jiangbailing      原始版本
 * 文件说明: 算法三->分光文件分析接口
 */
@Data
public class AiSplittingLightFileAnalyzeInfo {
    private Double   total_size ;
    private Double   cie_x ;
    private Double   cie_y ;
    private Double   cie_x_std ;
    private Double   cie_y_std ;
    private Double   cie_xy_corr ;
    private Double   euclidean_distance_xy ;
    private Double   euclidean_distance_x ;
    private Double   euclidean_distance_y ;
    private Double   ra_mean ;
    private Double   ra_media;
    private Double   ra_min;
    private Double   ra_max;
    private Double   ra_std;
    private Double   ra_yield;
    private Double   lm_mean;
    private Double   lm_media;
    private Double   lm_min;
    private Double   lm_max;
    private Double   lm_std;
    private List<Double>  bin_result;

}
