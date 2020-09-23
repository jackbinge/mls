package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/5/23     jiangbailing      原始版本
 * 文件说明:
 */
@Data
public class TaskStateForDatabase {
    private Long id;
    private Long taskId;
    private Long taskDfId;
    private Long modelId;
    private String createTime;
    private Integer isActive;
    private String modelCreateTime;
    private String ratioCreateTime;
    private Integer processType;
    private String processCreateTime;
    private Integer processVersion;
    private Long processInitiator;
    private String initiateReason;
    private Integer modelVersion;
    private Integer ratioVersion;
    private Long modelCreator;
    private Long ratioCreator;
    private Integer rar9Type;
    private Integer ratioSource;
    private Long outputRequireBeforeTestRuleId;
    private Long outputRequireNbakeRuleId;
    private String fileidList;
}
