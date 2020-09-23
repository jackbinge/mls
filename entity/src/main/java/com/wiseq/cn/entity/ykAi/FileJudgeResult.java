package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/6/1     jiangbailing      原始版本
 * 文件说明:
 */
@Data
public class FileJudgeResult {
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
    private String judgeResult;//判定结果
    private String judgeType;//判定过程 改判还是强制通过
    private String fileState;//-1未判定，0 ok 1 NG
}
