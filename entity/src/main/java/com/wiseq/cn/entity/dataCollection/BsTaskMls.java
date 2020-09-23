package com.wiseq.cn.entity.dataCollection;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BsTaskMls {
    private Integer id;
    private String taskCode;
    private String type;//工单类型，0量产单 1 样品单
    private String woId;
    private Integer state;
    private Integer systemTaskType;//0 EAS工单，1是纯打样工单
}
