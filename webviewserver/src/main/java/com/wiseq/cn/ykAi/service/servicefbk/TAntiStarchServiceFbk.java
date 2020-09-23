package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TAntiStarch;
import com.wiseq.cn.ykAi.service.TAntiStarchService;
import org.springframework.stereotype.Service;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-抗沉淀粉
 */
@Service
public class TAntiStarchServiceFbk implements TAntiStarchService {

    @Override
    public Result insert(TAntiStarch tAntiStarch) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result update(TAntiStarch tAntiStarch) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result findList(String antiStarchSpec, Boolean disabled, Integer pageNum, Integer pageSize) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result updateDisabled(TAntiStarch tAntiStarch) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result updateDel(TAntiStarch tAntiStarch) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
