package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.ykAi.service.UploadLicenseService;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class UploadLicenseServiceFbk implements UploadLicenseService {
    @Override
    public Result uploadLicense(MultipartFile file) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
