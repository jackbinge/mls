package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TPhosphor;
import com.wiseq.cn.ykAi.service.TPhosphorService;
import org.springframework.stereotype.Service;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-荧光粉
 */
@Service
public class TPhosphorServiceFbk implements TPhosphorService {

    @Override
    public Result insert(TPhosphor tPhosphor) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result update(TPhosphor tPhosphor) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result tPhosphorFindList(String phosphorSpec, Boolean disabled, Integer pageNum, Integer pageSize, String phosphorType, Integer phosphorTypeId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

   /* @Override
    public Result findList(String phosphorSpec, Boolean disabled, Integer pageNum, Integer pageSize,String phosphorType) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }*/

    @Override
    public Result updateDisabled(TPhosphor tPhosphor) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result updateDel(TPhosphor tPhosphor) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
