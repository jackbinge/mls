package com.wiseq.cn.ykAi.service;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TEqpt;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/5     lipeng      原始版本
 * 文件说明:
 */
public interface TEqptService {
//    int insert(JSONObject jsonObject);
//
//    int update(JSONObject jsonObject);

    int updateDisabled(TEqpt tEqpt);

    int updateDel(TEqpt tEqpt);

    PageInfo findList(String chipSpec, Boolean disabled, Integer pageNum, Integer pageSize);
}

