package com.wiseq.cn.entity.dataCollection;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class SpcXyData {
    private List<PointsInfos> points_infos_x;
    private List<PointsInfos> points_infos_y;
    private ClInfos cl_infos_x;
    private ClInfos cl_infos_y;
    private SpcxyRule spcxyRule;
    private QcInfo qc_info;
    private List<String> total_reason_x;
    private List<String> total_reason_y;
}
