package com.wiseq.cn.ykAi.dao;

import java.util.List;

import com.wiseq.cn.entity.ykAi.TGlueDtl;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/31       lipeng      原始版本
 * 文件说明:原材料库-胶水信息
 */
public interface TGlueDtlDao {

    void insertSelective(TGlueDtl record);

    List<TGlueDtl> findExist(@Param("glueSpec") String glueSpec, @Param("glueDtlId") Long glueDtlId);

    void update(TGlueDtl tGlueDtl);
}