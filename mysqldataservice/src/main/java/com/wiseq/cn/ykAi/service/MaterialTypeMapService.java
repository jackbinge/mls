package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.MaterialTypeMap;
import com.wiseq.cn.entity.ykAi.MaterialTypeMapMix;

import java.util.List;

/**
* 版本          修改时间      作者       修改内容
* V1.0         2019/11/8     lipeng      原始版本
* 文件说明:
*/
public interface MaterialTypeMapService {


    Result insert(List<MaterialTypeMap> materialTypeMapList);

    Result update(MaterialTypeMapMix materialTypeMapMix);


    Result findList(Byte materalType, String mapRule, Integer pageNum, Integer pageSize);
}
