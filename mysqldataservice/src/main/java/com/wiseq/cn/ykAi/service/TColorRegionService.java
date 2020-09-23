package com.wiseq.cn.ykAi.service;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TColorRegion;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/11/6       lipeng      原始版本
 * 文件说明:色区
 */
public interface TColorRegionService {


    PageInfo findList(String spec, Byte processType, Integer pageNum, Integer pageSize);
    @Transactional
    Result updateDelbunch(List<TColorRegion> tColorRegionList);
}
