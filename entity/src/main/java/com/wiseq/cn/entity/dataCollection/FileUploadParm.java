package com.wiseq.cn.entity.dataCollection;

import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

@Getter
@Setter
public class FileUploadParm {

    private MultipartFile file;
    private String userId;
    private String eqptValueId;
    private String billNum;
    private Integer type;
}
