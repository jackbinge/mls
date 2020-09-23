package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.entity.ykAi.TChip;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/28       lipeng      原始版本
 * 文件说明:  原材料库-芯片
 */
public interface TChipDao {
    int deleteByPrimaryKey(Long id);

    int insert(TChip record);

    TChip selectByPrimaryKey(Long id);
    //修改
    int update(TChip record);

    int update2(TChip record);

    List<TChip> findExistList(@Param("chipSpec") String chipSpec, @Param("id") Long id);

    List<TChip> findList(@Param("chipSpec") String chipSpec, @Param("disabled") Boolean disabled);

    int updateDisabled(TChip tChip);

    int updateDel(TChip tChip);


    /**
     * 通过BOMid获取芯片列表（配比库使用，勿动）
     *
     * @param id
     * @return
     */
    List<TChip> findChipMixByTbomId(@Param("id") Long id);
}