package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TTypeMachine;
import com.wiseq.cn.ykAi.service.TTypeMachineService;
import org.springframework.stereotype.Service;

@Service
public class TTypeMachineServiceFbk implements TTypeMachineService {
    @Override
    public Result selectAll(String spec, Byte processType, Boolean disabled, Integer pageNum, Integer pageSize,Integer crystalNumber) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result insert(TTypeMachine record) {

        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result delete(Long id) {

        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result updateByPrimaryKeySelective(TTypeMachine record) {

        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result updateOnAndOff(TTypeMachine record) {

        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result findTypeMatchineListForTest(String spec, Byte processType, Integer pageNum, Integer pageSize, Integer crystalNumber) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result findTypeMachineById(Long typeMachineId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
