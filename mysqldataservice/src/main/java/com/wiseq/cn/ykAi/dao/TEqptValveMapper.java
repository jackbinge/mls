package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.entity.ykAi.TEqptValve;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/5     lipeng      原始版本
 * 文件说明:
 */
public interface TEqptValveMapper {
    int deleteByPrimaryKey(Long id);

    int insertSelective(TEqptValve record);

    int updateByPrimaryKeySelective(TEqptValve record);

    int updateByPrimaryKey(TEqptValve record);

    List<TEqptValve> findTEqptValveExist(@Param("name") String name, @Param("eqptId") Long eqptId);

    void updateByPrimaryKeySelectives(TEqptValve tEqptValve);

    /**
     * 删除
     *
     * @param tEqptValve
     */
    void deleteSelectives(TEqptValve tEqptValve);

    TEqptValve selectByPrimaryKey(Long id);

    List<TEqptValve> findTeqptValveList(@Param("eqptId") Long eqptId);


}