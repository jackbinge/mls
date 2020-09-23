package com.wiseq.cn.entity.dataCollection;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SpcxyRule {
    private String qc_point;
    private String delta_x_ucl;
    private String delta_x_lcl;
    private String delta_y_ucl;
    private String delta_y_lcl;
    private String cl_optional;
    private String spcRule;
}
