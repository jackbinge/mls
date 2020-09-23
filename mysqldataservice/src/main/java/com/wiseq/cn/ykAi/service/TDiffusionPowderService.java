package com.wiseq.cn.ykAi.service;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.entity.ykAi.TDiffusionPowder;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/30       lipeng      原始版本
 * 文件说明:  原材料库-扩散粉
 */
public interface TDiffusionPowderService {


    int insert(TDiffusionPowder tDiffusionPowder);

    int update(TDiffusionPowder tDiffusionPowder);

    int updateDisabled(TDiffusionPowder tDiffusionPowder);

    int updateDel(TDiffusionPowder tDiffusionPowder);

    PageInfo findList(String diffusionPowderSpec, Boolean disabled, Integer pageNum, Integer pageSize);
}
