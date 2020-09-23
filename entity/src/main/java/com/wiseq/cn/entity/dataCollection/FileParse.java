package com.wiseq.cn.entity.dataCollection;

import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.Map;

@Getter
@Setter
public class FileParse {
    private List<Double> Ra;
    private List<Double> CRI9;
    private List<Double> LM;
    private List<List<Double>> xy;
    private List<Object> dic_x;
    private List<Object> dic_y;
    private List<Object> dic_lm;
    private List<Object> dic_ra;
    private List<Object> dic_r9;
}
