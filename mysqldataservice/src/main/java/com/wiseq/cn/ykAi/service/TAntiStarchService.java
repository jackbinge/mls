package com.wiseq.cn.ykAi.service;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.entity.ykAi.TAntiStarch;
    /**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/30       lipeng      原始版本
 * 文件说明:  原材料库-抗沉淀粉
 */
public interface TAntiStarchService {


        int insert(TAntiStarch tAntiStarch);

        int update(TAntiStarch tAntiStarch);

        int updateDisabled(TAntiStarch tAntiStarch);

        int updateDel(TAntiStarch tAntiStarch);

        PageInfo findList(String antiStarchSpec, Boolean disabled, Integer pageNum, Integer pageSize);
    }
