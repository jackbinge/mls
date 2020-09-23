package com.wiseq.cn.ykAi.dao;

import java.util.List;

import com.wiseq.cn.entity.ykAi.TNoneBakeTestRule;
import com.wiseq.cn.entity.ykAi.TOutputRequireNbakeRule;
import org.apache.ibatis.annotations.Param;

public interface TNoneBakeTestRuleDao {
    int deleteByPrimaryKey(Long id);

    int insert(TNoneBakeTestRule record);

    int insertSelective(TNoneBakeTestRule record);

    TNoneBakeTestRule selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(TNoneBakeTestRule record);

    int updateByPrimaryKey(TNoneBakeTestRule record);

    int updateBatch(List<TNoneBakeTestRule> list);

    int batchInsert(@Param("list") List<TNoneBakeTestRule> list);

    /**
     * 获取类型和详情
     *
     * @param outputRequireId
     * @return
     */
    List<TOutputRequireNbakeRule> findTOutputRequireNbakeRuleByOutputRequireId(@Param("outputRequireId") Long outputRequireId);

    /**
     * 删除中间表数据通过非正常烤测试数据ID
     *
     * @param noneBakeRuleId
     * @return
     */
    int deleteTOutputRequireNbakeRuleById(@Param("noneBakeRuleId") Long noneBakeRuleId);


    /**
     * 通过出货要求删除
     * @param outputRequireId
     * @return
     */
    int deleteTOutputRequireNbakeRuleByOutputRequireId
    (@Param("outputRequireId") Long outputRequireId);

    /**
     * 新增
     *
     * @param tOutputRequireNbakeRule
     * @return
     */
    int insertTOutputRequireNbakeRule(TOutputRequireNbakeRule tOutputRequireNbakeRule);
}