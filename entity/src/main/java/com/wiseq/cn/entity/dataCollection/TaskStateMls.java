package com.wiseq.cn.entity.dataCollection;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TaskStateMls {
    private  Integer id;
    private  Integer taskId;
    private  Integer taskDfId;
    private  Integer modelId;
    private  Integer processType;//流程类型
    private  Integer processInitiator;//流程发起人
    private  Integer initiateReason;//发起流程的原因
    private  Integer modelCreator;//配方操作人
    private  Integer rar9Type;//忽略raR9
    private  Integer ratioVersion;
    private  Integer ratioCreator;
    private  String ratioSource;

}
