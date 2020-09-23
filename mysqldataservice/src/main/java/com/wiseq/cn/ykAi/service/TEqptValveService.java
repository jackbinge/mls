package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.entity.ykAi.TEqptValve;

/**
* 版本          修改时间      作者       修改内容
* V1.0         2019/11/5     lipeng      原始版本
* 文件说明:
*/
public interface TEqptValveService {


int deleteByPrimaryKey(Long id);

int insertSelective(TEqptValve record);

TEqptValve selectByPrimaryKey(Long id);

int updateByPrimaryKeySelective(TEqptValve record);

int updateByPrimaryKey(TEqptValve record);

}
