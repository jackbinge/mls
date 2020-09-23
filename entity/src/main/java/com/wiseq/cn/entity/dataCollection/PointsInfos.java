package com.wiseq.cn.entity.dataCollection;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class PointsInfos {
    private String point;
    private String label;
    private List<String> reason;
    private String create_time;
}
