package com.wiseq.cn.ykAi.service;


import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TGlue;
import com.wiseq.cn.entity.ykAi.TGlueMix;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/31       lipeng      原始版本
 * 文件说明:  原材料库-胶水比例
 */
public interface TGlueMixService {
        @Transactional
        Result insert(List<TGlueMix> tGlueMixList);
        @Transactional
        Result update(List<TGlueMix> tGlueMixList);


    }
