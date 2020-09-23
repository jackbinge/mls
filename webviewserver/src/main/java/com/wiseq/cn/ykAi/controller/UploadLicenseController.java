package com.wiseq.cn.ykAi.controller;


import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.ykAi.service.UploadLicenseService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@Api(value = "license上传")
@RequestMapping("/upload")
public class UploadLicenseController {

    @Autowired
    private UploadLicenseService uploadLicenseService;

    @PostMapping("/uploadLicense")
    @ApiOperation(value = "上传license文件")
    public Result uploadLicense(@RequestPart("file") MultipartFile file){
        return uploadLicenseService.uploadLicense(file);
    }
}
