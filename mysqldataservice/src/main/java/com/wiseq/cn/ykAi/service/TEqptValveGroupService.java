package com.wiseq.cn.ykAi.service;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TEqpt;
import com.wiseq.cn.entity.ykAi.TEqptValve;
import com.wiseq.cn.entity.ykAi.TEqptValveGroup;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/5     lipeng      原始版本
 * 文件说明:点胶页面
 */
public interface TEqptValveGroupService {
    @Transactional
    Result insert(TEqptValveGroup tEqptValveGroup);

    int updateDisabled(Long id, Boolean disable);

    int updateDel(Long id);

    @Transactional
    Result updateEqpt(TEqpt tEqpt);

    PageInfo findList(Long groupId, String positon, String assetsCode, Boolean disabled, Integer pageNum, Integer pageSize);

    List<TEqptValve> findTeqptValveList(Long eqptId);
}

