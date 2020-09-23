package com.wiseq.cn.entity.webview;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class UploadLog {
    private Integer logId;
    private String uploadDate;
    private String tableName;
    private Integer uploadState;
}
