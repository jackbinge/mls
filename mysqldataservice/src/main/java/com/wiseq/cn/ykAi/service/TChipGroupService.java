package com.wiseq.cn.ykAi.service;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TChipGroup;
import org.springframework.transaction.annotation.Transactional;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/9/10       lipeng      原始版本
 * 文件说明:原材料库-芯片
 */
public interface TChipGroupService {

    @Transactional
    Result update(TChipGroup tChipGroup);
    @Transactional
    Result insert(TChipGroup tChipGroup);
}
