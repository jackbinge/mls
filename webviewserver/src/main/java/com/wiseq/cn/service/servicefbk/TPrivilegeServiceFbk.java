package com.wiseq.cn.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.ykAi.service.TPrivilegeService;
import org.springframework.stereotype.Service;

@Service
public class TPrivilegeServiceFbk implements TPrivilegeService {
    @Override
    public Result getBaseTree() {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getUserTree(Long id) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
