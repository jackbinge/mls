package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.config.FeignMultipartSupportConfig;
import com.wiseq.cn.ykAi.service.servicefbk.ProductServiceFbk;
import com.wiseq.cn.ykAi.service.servicefbk.UploadLicenseServiceFbk;
import io.swagger.annotations.ApiOperation;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;

@FeignClient(value = "easwo-dataService/upload",configuration = FeignMultipartSupportConfig.class, fallback = UploadLicenseServiceFbk.class)
public interface UploadLicenseService {


    @PostMapping(value = "/uploadLicense",produces = {MediaType.APPLICATION_JSON_UTF8_VALUE},
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @ApiOperation(value = "上传license文件")
    public Result uploadLicense(@RequestPart("file") MultipartFile file);
}
