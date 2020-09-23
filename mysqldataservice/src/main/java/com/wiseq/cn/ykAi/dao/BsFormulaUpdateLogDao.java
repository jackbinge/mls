package com.wiseq.cn.ykAi.dao;


import java.util.List;

import com.wiseq.cn.entity.ykAi.BsFormulaUpdateLog;
import com.wiseq.cn.entity.ykAi.BsFormulaUpdateLongPage;
import org.apache.ibatis.annotations.Param;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/12      jiangbailing      原始版本
 * 文件说明:基础库-配比修改记录表
 */
public interface BsFormulaUpdateLogDao {


    int insertSelective(BsFormulaUpdateLog record);

    //废弃
    BsFormulaUpdateLog selectByPrimaryKey(Long id);

    /**
     * 获取变更日志
     * @param modelBomId
     * @return
     */
    List<BsFormulaUpdateLongPage> selectFormulaUpdteLog(@Param("modelBomId") Long modelBomId);
}