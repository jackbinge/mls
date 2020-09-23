package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.entity.ykAi.TAntiStarch;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/30       lipeng      原始版本
 * 文件说明:  原材料库-抗沉淀粉
 */
public interface TAntiStarchDao {

    List<TAntiStarch> findExistList(String antiStarchSpec);

    int insert(TAntiStarch tAntiStarch);

    int update(TAntiStarch tAntiStarch);

    int updateDisabled(TAntiStarch tAntiStarch);

    int updateDel(TAntiStarch tAntiStarch);

    List<TAntiStarch> findList(@Param("antiStarchSpec")String antiStarchSpec,
                               @Param("disabled")Boolean disabled);
}