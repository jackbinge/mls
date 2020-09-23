package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.ykAi.service.TPhosphorTypeService;
import org.springframework.stereotype.Service;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/11     jiangbailing      原始版本
 * 文件说明:
 */
@Service
public class TPhosphorTypeServiceFbk implements TPhosphorTypeService {
    @Override
    public Result select() {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result delete(String id) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result add(String name) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getSomeTypePosphor(String phosphorTypes) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
