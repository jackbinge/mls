package com.wiseq.cn.ykAi.service;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TPhosphor;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/9/10       lipeng      原始版本
 * 文件说明:原材料库-荧光粉
 */
public interface TPhosphorService {

    int insert(TPhosphor record);

    int update(TPhosphor record);

    int updateDisabled(TPhosphor tPhosphor);

    int updateDel(TPhosphor tPhosphor);

    //long getPhSpec(long specId);

    PageInfo findList(String phosphorSpec, Boolean disabled, Integer pageNum, Integer pageSize,String phosphorType,Integer phosphorTypeId);
}
