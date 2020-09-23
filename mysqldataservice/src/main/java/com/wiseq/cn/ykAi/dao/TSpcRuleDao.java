package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.entity.ykAi.TSpcBaseRule;
import com.wiseq.cn.entity.ykAi.TSpcRule;
import com.wiseq.cn.entity.ykAi.TSpcRuleDtl;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/8      jiangbailing      原始版本
 * 文件说明:基础库-测试规则-SPC基础表
 */
public interface TSpcRuleDao {
    /**
     * 获取spc质控规则
     * @param typeMachineId
     * @return
     */
    TSpcRule selectSpcRuleByTypeMachineId(Long typeMachineId);



    /**
     * 获取spc详情通过指控id
     * @param qcRuleId
     * @return
     */
    List<TSpcRuleDtl> selectSpcRuleDtlByQcRuleId(Long qcRuleId);

    /**
     * 获取spc模板
     * @return
     */
    List<TSpcBaseRule> selectSpcBaseRule();

    /**
     * 新增spc指控规则表
     * @param tSpcRule
     * @return
     */
    int insertSpcRuleSelective(TSpcRule tSpcRule);

    /**
     * 删除spc详情规则表 通过指控表ID
     * @param qcRuleId
     * @return
     */
    int deleteTSpcRuleDtlByQcRuleId(Long qcRuleId);


    /**
     * 新增spc规则
     * @param tSpcRuleDtls
     * @return
     */
    int batchInsertTSpcRuleDtl(List<TSpcRuleDtl> tSpcRuleDtls);

    /**
     * 修改
     * @param tSpcRule
     * @return
     */
    int updateTSpcRuleSelective(TSpcRule tSpcRule);
}
