package com.wiseq.cn.entity.webview;

import com.wiseq.cn.entity.annotations.Numberic;
import lombok.Getter;
import lombok.Setter;
import org.springframework.format.annotation.DateTimeFormat;

import javax.validation.constraints.NotNull;
import java.sql.Timestamp;

/**
 * 版本        修改时间        编者      备注
 * V1.0        ------        jpdong    原始版本
 * 文件说明: 定时任务实体
 **/
@Setter
@Getter
public class TimerTask {
    private Integer jobId;
    @NotNull
    private String jobName;
    private String param;

    @Numberic(maxValue = 999999999, minValue = -9999999, message = "非法时长")
    private Integer timeOut;

    @Numberic(maxValue = 999999999, minValue = -9999999, message = "非法优先级")
    private Integer level;

    @Numberic(maxValue = 1, minValue = 0, message = "非法任务类型")
    private Integer taskType;

    @NotNull
    private String taskClassName;

    @NotNull
    private String jarPath;

    private String jarMethodName;

    @Numberic(maxValue = 1, minValue = 0, message = "非法方法类型")
    private Integer jarMethodType;

    private Timestamp createTime;

    private String frontTask;
}
