package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.entity.ykAi.BsTaskFormulaDtl;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/21     jiangbailing      原始版本
 * 文件说明:  
 */
@Mapper
public interface BsTaskFormulaDtlDao {


    int batchInsert(@Param("list") List<BsTaskFormulaDtl> list);

    /**
     *
     * @param record
     * @return
     */
    int insert(BsTaskFormulaDtl record);

    

}