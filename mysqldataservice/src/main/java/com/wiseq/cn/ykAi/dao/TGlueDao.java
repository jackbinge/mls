package com.wiseq.cn.ykAi.dao;

import java.util.List;

import com.wiseq.cn.entity.ykAi.TABGlue;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TGlue;
import org.apache.ibatis.annotations.Param;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/31       lipeng      原始版本
 * 文件说明:  原材料库-胶水比例
 */
public interface TGlueDao {

    /**
     * 删除
     * @param tGlue
     * @return
     */
    int updateDel(TGlue tGlue);

    /**
     * 禁用
     * @param tGlue
     * @return
     */
    int updateDisabled(TGlue tGlue);

    /**
     * 新增
     * @param tGlue
     */
    void insert(TGlue tGlue);


    /**
     * 修改
     * @param tGlue
     */
    void update(TGlue tGlue);

    /**
     *
     * @param glueSpec
     * @param disabled
     * @return
     */
    List<TABGlue> findList(@Param("glueSpec")String glueSpec, @Param("disabled") Boolean disabled);

}