package com.wiseq.cn.entity.dataCollection;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UploadFileParm {
    private Integer id;
    private String path;
    private Integer type;
    private Integer userId;
    private Integer eqptValueId;
    private String digest;
    private Integer taskStateId;
}
