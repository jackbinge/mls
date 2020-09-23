package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.entity.ykAi.TOutputRequirementsDtl;
import java.util.List;
import org.apache.ibatis.annotations.Param;
/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/7      jiangbailing      原始版本
 * 文件说明:基础库-机种库
 */
public interface TOutputRequirementsDtlMapper {
    int deleteByPrimaryKey(Long id);

    int deleteByORidAndCRid(Long outputRequireId,Long colorRegionId);

    int insert(TOutputRequirementsDtl record);

    int insertSelective(TOutputRequirementsDtl record);

    TOutputRequirementsDtl selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(TOutputRequirementsDtl record);

    int updateByColorRegionIdSelective(TOutputRequirementsDtl record);

    int updateByPrimaryKey(TOutputRequirementsDtl record);

    int updateBatch(List<TOutputRequirementsDtl> list);

    int batchInsert(@Param("list") List<TOutputRequirementsDtl> list);
}