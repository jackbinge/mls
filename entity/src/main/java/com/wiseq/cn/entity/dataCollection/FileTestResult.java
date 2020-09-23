package com.wiseq.cn.entity.dataCollection;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FileTestResult {
    private String id;
    private String eqptValueId;
    private String taskStateId;
    private String userName;
    private String createTime;
    private String classType;
    //private String eqptState;
    private String ratio;
    private String dosage;
    private Double dosageNum;
    private String stateName;
}
