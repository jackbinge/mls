package com.wiseq.cn.entity.dataCollection;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class SpcBinData {
    private List<PointsInfos> points_infos;
    private ClInfos cl_infos;
    private SpcBinRule spcBinRule;
    private QcInfo qc_info;
    private List<String> total_reason;
}
