package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TChipWlRank;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/28       lipeng      原始版本
 * 文件说明:
 */
public interface TChipWlRankDao {

    List<TChipWlRank> findtChipWlRankExistList(@Param("name") String name);



    int updateDelete(TChipWlRank tChipWlRank);

    List<TChipWlRank> findAll(@Param("chipId") Long chipId);

    void insert(TChipWlRank tChipWlRank);

    List<TChipWlRank> tChipWlRankExistList(@Param("name") String name);

    void update(TChipWlRank tChipWlRank);

    //批量修改而非删除
    void batchUpdate(List<TChipWlRank> tChipWlRankDelList);

    //批量删除
    void batchDelete(List<TChipWlRank> tChipWlRankDelList);

    TChipWlRank findTChipWlRank(@Param("id") Long id);
}