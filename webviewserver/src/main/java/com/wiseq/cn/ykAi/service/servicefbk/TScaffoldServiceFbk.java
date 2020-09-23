package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TScaffold;
import com.wiseq.cn.ykAi.service.TScaffoldService;
import org.springframework.stereotype.Service;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-支架
 */
@Service
public class TScaffoldServiceFbk implements TScaffoldService {

    @Override
    public Result insert(TScaffold tScaffold) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result update(TScaffold tScaffold) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result findList(String scaffoldSpec, Boolean disabled, Integer pageNum, Integer pageSize, Byte scaffoldType) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result updateDisabled(TScaffold tScaffold) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result updateDel(TScaffold tScaffold) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
