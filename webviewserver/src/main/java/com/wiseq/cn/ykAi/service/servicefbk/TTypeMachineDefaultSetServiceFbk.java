package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TTypeMachineDefaultSetFrontToBack;
import com.wiseq.cn.ykAi.service.TTypeMachineDefaultSetService;
import org.springframework.stereotype.Service;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/13     jiangbailing      原始版本
 * 文件说明:
 */
@Service
public class TTypeMachineDefaultSetServiceFbk implements TTypeMachineDefaultSetService {

    @Override
    public Result set(TTypeMachineDefaultSetFrontToBack data) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result select(Integer typeMachineId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
