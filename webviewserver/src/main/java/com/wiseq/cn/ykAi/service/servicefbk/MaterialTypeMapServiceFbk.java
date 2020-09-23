package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.MaterialTypeMap;
import com.wiseq.cn.entity.ykAi.MaterialTypeMapMix;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.ykAi.service.MaterialTypeMapService;
import com.wiseq.cn.ykAi.service.TChipService;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-芯片
 */
@Service
public class MaterialTypeMapServiceFbk implements MaterialTypeMapService {

    @Override
    public Result insert(List<MaterialTypeMap> materialTypeMapList) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result update(MaterialTypeMapMix materialTypeMapMix) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result materialTypeMapFindList(Byte materalType, String mapRule, Integer pageNum, Integer pageSize) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }


}
