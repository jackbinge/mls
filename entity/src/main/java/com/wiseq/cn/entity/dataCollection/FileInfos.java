package com.wiseq.cn.entity.dataCollection;

import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.Map;

@Getter
@Setter
public class FileInfos {
    private Double total_size;
    private Double cie_x;
    private Double cie_y;
    private Double cie_x_std;
    private Double cie_y_std;
    private Double cie_xy_corr;
    private Double euclidean_distance_xy;
    private Double euclidean_distance_x;
    private Double euclidean_distance_y;
    private Double ra_mean;
    private Double ra_media;
    private Double ra_min;
    private Double ra_max;
    private Double ra_std;
    private Double ra_yield;
    private Double cri9_mean;
    private Double cri9_media;
    private Double cri9_min;
    private Double cri9_max;
    private Double cri9_std;
    private Double lm_mean;
    private Double lm_media;
    private Double lm_min;
    private Double lm_max;
    private Double lm_std;
    private Map<Integer,Double> bin_result;
    private List<ColorArea> bin_result_real;
    private Double totalRate;
    private String ra_target;
    private String ra_round;
    private String r9;
    private Double r9_yield;
    private Double lumen_lsl;
    private Double lumen_usl;
    private Double ra_re_max;
    private Double ra_re_min;

}
