package com.wiseq.cn.entity.dataCollection;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class FileNgResult {
    private String id;
    private String judgeUser;
    private String judgeTime;
    //private String eqptValueId;
    private String userName;
    private String createTime;
    private String classType;
    //private String eqptState;
    private String ratio;
    private String dosage;
    private Double dosageNum;
    private String stateName;
    private String eqptValueId;
    private String taskStateId;
}
