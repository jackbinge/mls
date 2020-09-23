package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TEqpt;
import com.wiseq.cn.entity.ykAi.TEqptValveGroup;
import com.wiseq.cn.ykAi.service.TChipService;
import com.wiseq.cn.ykAi.service.TEqptValveGroupService;
import org.springframework.stereotype.Service;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/11/5      lipeng      原始版本
 * 文件说明:点胶设备
 */
@Service
public class TEqptValveGroupServiceFbk implements TEqptValveGroupService {

    @Override
    public Result insert(TEqptValveGroup tEqptValveGroup) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result updateDisabled(Long id, Boolean disable) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result updateDel(Long id) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }


    @Override
    public Result findList(Long groupId, String positon, String assetsCode, Boolean disabled, Integer pageNum, Integer pageSize) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result findTeqptValveList(Integer eqptId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result updateEqpt(TEqpt tEqpt) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
