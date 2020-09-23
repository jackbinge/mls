package com.wiseq.cn.ykAi.service;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TChipWlRank;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/9/10       lipeng      原始版本
 * 文件说明:原材料库-芯片
 */
public interface TChipService{

    int insert(JSONObject jsonObject);

    int update(JSONObject jsonObject);

    int updateDisabled(TChip tChip);

    int updateDel(TChip tChip);

    PageInfo findList(String chipSpec, Boolean disabled, Integer pageNum, Integer pageSize);
}
