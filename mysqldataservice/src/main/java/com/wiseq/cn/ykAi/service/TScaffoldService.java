package com.wiseq.cn.ykAi.service;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TScaffold;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/9/10       lipeng      原始版本
 * 文件说明:原材料库-支架
 */
public interface TScaffoldService {

    int insert(TScaffold tScaffold);

    int update(TScaffold tScaffold);

    int updateDisabled(TScaffold tScaffold);

    int updateDel(TScaffold tScaffold);

    PageInfo findList(String chipSpec, Boolean disabled, Integer pageNum, Integer pageSize,Byte scaffoldType);
}
