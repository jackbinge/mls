package com.wiseq.cn.entity.dataCollection;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SpcBinRule {
    private String qc_point;
    private String ucl;
    private String lcl;
    private String cl_optional;
    private String spcRule;
}
