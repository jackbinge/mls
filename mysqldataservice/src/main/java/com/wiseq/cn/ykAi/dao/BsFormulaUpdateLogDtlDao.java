package com.wiseq.cn.ykAi.dao;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/12      jiangbailing      原始版本
 * 文件说明:基础库-配比修改日志-详情表
 */
import java.util.List;
import java.util.Map;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/12      jiangbailing      原始版本
 * 文件说明:基础库-配比修改日志
 */
import com.wiseq.cn.entity.ykAi.BsFormulaTargetParameter;
import com.wiseq.cn.entity.ykAi.BsFormulaUpdateLogDtl;
import org.apache.ibatis.annotations.Param;

public interface BsFormulaUpdateLogDtlDao {

    //查询 --废弃
    BsFormulaUpdateLogDtl selectByPrimaryKey(Long id);

    //新增
    int batchInsert(@Param("list") List<BsFormulaUpdateLogDtl> list);


    //新增目标参数表
    int insertTargetParameter(BsFormulaTargetParameter bsFormulaTargetParameter);


    //通过modelBomId获取机种的目标参数
    BsFormulaTargetParameter selectTypeMachineTargetParameterByModelBomId(@Param("modelBomId") Long modelBomId);

    //获取配比的目标参数
    BsFormulaTargetParameter selectRatioTargetParameter(@Param("bsFormulaUpdateLogId") Long bsFormulaUpdateLogId);

    //通过modelBomId获取机种的目标参数
    BsFormulaTargetParameter selectTypeMachineTargetParameterByModelId(@Param("modelId") Long modelId);
}