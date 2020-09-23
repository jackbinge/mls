package com.wiseq.cn.ykAi.dao;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TDiffusionPowder;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/30       lipeng      原始版本
 * 文件说明:  
 */
public interface TDiffusionPowderDao {


    List<TDiffusionPowder> findExistList(String diffusionPowderSpec);

    int insert(TDiffusionPowder tDiffusionPowder);

    int update(TDiffusionPowder tDiffusionPowder);

    int updateDisabled(TDiffusionPowder tDiffusionPowder);

    int updateDel(TDiffusionPowder tDiffusionPowder);

    List<TDiffusionPowder> findList(@Param("diffusionPowderSpec")String diffusionPowderSpec,@Param("disabled") Boolean disabled);
}