package com.wiseq.cn.ykAi.dao;

import com.alibaba.fastjson.JSONObject;
import com.wiseq.cn.entity.ykAi.*;
import org.apache.ibatis.annotations.Param;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 版本        修改时间        作者                修改内容
 * V1.0     2019/10/29       jiangbailing      原始版本
 * 文件说明:机种-BOM组合
 */
public interface TBomDao {
    /**
     * 新增
     *
     * @param record
     * @return
     */
    int insertSelective(TBom record);

    /**
     * 删除
     *
     * @param id
     * @return
     */
    int deleteByPrimaryKey(Long id);

    /**
     * 通过机种ID获取这个机种的所有BOM组合，暂不包含荧光粉
     *
     * @param typeMachineId
     * @return
     */
    List<TBom> selectAllByTypeMachineId(@Param("typeMachineId") Long typeMachineId,
                                        @Param("isTemp") Boolean isTemp,
                                        @Param("bomCode") String bomCode,
                                        @Param("bomType") Byte bomType,
                                        @Param("bomSource") Integer bomSource);


    /**
     * 通过bomId获得这个BOM的所有荧光粉信息
     *
     * @param bomId
     * @return
     */
    List<TPhosphor> selectPhosphorByBomId(@Param("bomId") Long bomId);


    /**
     * 获取所有非禁用和删除的胶水列表
     *
     * @return
     */
    List<TABGlue> getTGlues();


    /**
     * 获取所有非禁用和删除的芯片列表
     *
     * @return
     */
    List<TChip> getTChips();

    /**
     * 获取所有非禁用和删除的荧光粉列表
     *
     * @return
     */
    List<TPhosphor> getTPhosphors();

    /**
     * 获取所有非禁用和删除的支架列表
     *
     * @return
     */
    List<TScaffold> getTScaffolds();

    /**
     * 获取BOM最长值
     *
     * @param typeMachineId
     * @return
     */
    Integer getBomMaxLength(@Param("typeMachineId") Long typeMachineId);

    /**
     * 批量新增bom荧光粉中间表
     *
     * @return
     */
    Integer batchInsertBomPhosphor(List<TBomPhosphor> tBomPhosphors);

    /**
     * 修改t_bom表
     *
     * @param tBom
     */
    Integer updateByPrimaryKeySelective(TBom tBom);


    /**
     * 通过BOMid获取bom
     *
     * @param bomId
     * @return
     */
    TBom getBomById(@Param("bomId") Long bomId);

    /**
     * @return
     */
    Integer finExit(@Param("bomCode") String bomCode,
                    @Param("typeMachineId") Long typeMachineId);


    /**
     * 验证BOM原材料重复 - 荧光粉
     *
     * @param antiStarchId
     * @param typeMachineId
     * @param glueId
     * @param diffusionPowderId
     * @return
     */
    List<TBomMaterial> findExitForMaterialPhosphor(
            @Param("antiStarchId") Long antiStarchId,
            @Param("typeMachineId") Long typeMachineId,
            @Param("glueId") Long glueId,
            @Param("diffusionPowderId") Long diffusionPowderId);

    /**
     * 验证BOM原材料重复 - 芯片
     *
     * @param antiStarchId
     * @param typeMachineId
     * @param glueId
     * @param diffusionPowderId
     * @return
     */
    List<TBomMaterial> findExitForMaterialChip(@Param("antiStarchId") Long antiStarchId,
                                               @Param("typeMachineId") Long typeMachineId,
                                               @Param("glueId") Long glueId,
                                               @Param("diffusionPowderId") Long diffusionPowderId);

    /**
     * 获取荧光粉列表
     *
     * @param bomId
     * @return
     */
    List<Long> findTPhosphorList(@Param("bomId") Long bomId);


    /**
     * 新增bom和芯片的关系表
     *
     * @param list
     * @param bomId
     * @return
     */
    int insertChipList(@Param("list") List<TBomChip> list, @Param("bomId") Long bomId);

    /**
     * 删除bom和芯片关系表当删除bom时先删除此表
     *
     * @param bomId
     * @return
     */
    int deleteChipListByBomId(@Param("bomId") Long bomId);

    /**
     * 获取bom所用的芯片列表
     *
     * @return
     */
    List<TBomChip> getChipList(@Param("bomId") Long bomId);


    /**
     * bom系统推荐时的目标参数
     *
     * @param bomId
     * @return
     */
    Map<String, Object> getTBomSystemRecommendTargetParameter(@Param("bomId") Long bomId);


    /**
     * bom系统推荐时的限制荧光粉
     *
     * @return
     */
    List<Map<String, Object>> getBomPhosphorForRecommendedlimitPhosphorType(@Param("bomId") Long bomId);


    /**
     * bom系统推荐时的必须要使用的荧光粉
     *
     * @param bomId
     * @return
     */
    List<Map<String, Object>> getBomMustUsePhosphor(@Param("bomId") Long bomId);


    /**
     * bom系统推荐时禁止使用的荧光粉
     *
     * @param bomId
     * @return
     */
    List<Map<String, Object>> getBomProhibitedPhosphor(@Param("bomId") Long bomId);

    /**
     * 新增目标参数
     *
     * @return
     */
    Integer insertTBomTargetParameter(TbomTargetParameter tbomTargetParameter);

    /**
     * 新增限制条件
     *
     * @return
     */
    Integer insertTBomPhosphorForRecommended(@Param("bomId") Long bomId, @Param("mustUsePhosphorId") String mustUsePhosphorId, @Param("prohibitedPhosphorId") String prohibitedPhosphorId, @Param("limitPhosphorType") String limitPhosphorType);

    /**
     * 获取该机种的目标参数
     *
     * @param typeMachineId
     * @return
     */
    TbomTargetParameter selectTypeMachineTargetParameter(@Param("typeMachineId") Long typeMachineId);

    List<Map<String, Object>> getUseCurrentBomAiModelList(Long bomId);

    int deleteByBomId(Long bomId);

    List<Map> getPosphorByIdList(@Param("posphor") List<String> posphor);

    /**
     * BOM对应的绿粉（波长最短的粉）
     * @param bomId
     * @return
     */
    String getBomMinimumWavelengthPhosphor(@Param("bomId") Long bomId);
}
