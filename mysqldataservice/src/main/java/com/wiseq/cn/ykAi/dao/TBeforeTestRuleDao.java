package com.wiseq.cn.ykAi.dao;

import java.util.List;

import com.wiseq.cn.entity.ykAi.TBeforeTestRule;
import com.wiseq.cn.entity.ykAi.TOutputRequireBeforeTestRule;
import org.apache.ibatis.annotations.Param;

public interface TBeforeTestRuleDao {
    int deleteByPrimaryKey(Long id);

    int insert(TBeforeTestRule record);

    /**
     * 前测详情新增
     * @param record
     * @return
     */
    int insertSelective(TBeforeTestRule record);


    int updateByPrimaryKeySelective(TBeforeTestRule record);

    int updateByPrimaryKey(TBeforeTestRule record);

    int updateBatch(List<TBeforeTestRule> list);

    int batchInsert(@Param("list") List<TBeforeTestRule> list);

    /**
     * 通过出货要求获取前测规则
     * @param outputRequireId
     * @return
     */
    List<TOutputRequireBeforeTestRule> findDtlByOutputRequireId(@Param("outputRequireId") Long outputRequireId);

    /**
     * 删除出货要求对测试规则中间表数据-假删除
     * @param beforeTestRuleId
     * @return
     */
    int deleteTOutputRequireBeforeTestRuleById(@Param("beforeTestRuleId") Long beforeTestRuleId);

    /**
     * 删除出货要求对测试规则中间表数据-假删除
     * @param outputRequireId
     * @return
     */
    int deleteTOutputRequireByOutputRequireId(@Param("outputRequireId") Long outputRequireId);

    /**
     *新增测试规则详情表
     * @return
     */
    int insertOutRequireToBeforeTestTable(TOutputRequireBeforeTestRule tOutputRequireBeforeTestRule);

}