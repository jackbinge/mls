package com.wiseq.cn.ykAi.service;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.entity.ykAi.TGlue;

import java.util.List;
    /**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/31       lipeng      原始版本
 * 文件说明:  原材料库-胶水信息
 */
public interface TGlueService {

        int updateDel(TGlue tGlue);

        int updateDisabled(TGlue tGlue);

        PageInfo findList(String glueSpec, Boolean disabled, Integer pageNum, Integer pageSize);
}
