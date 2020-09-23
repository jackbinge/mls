package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.dataCollection.FileUploadParm;
import com.wiseq.cn.ykAi.service.QualityService;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class QualityServiceFbk implements QualityService {

    @Override
    public Result getEqptValueList(String billNum, Long taskStateId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result uploadFile(MultipartFile file, String userId, String eqptValueId, String billNum, Integer type,Integer taskStateId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getTestResultInfo(Integer taskStateId, String eqptValueId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getNgRecord(Integer taskId, String eqptValueId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getAlgorithmData(String fileId,String eqptValueId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getSpcData(Integer taskId, Integer eqptValueId, Integer testType, Integer modelId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }


}
