package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/21     jiangbailing      原始版本
 * 文件说明:在线推bom,前端给后端传
 */
@Data
public class OnLineRecommendFrontToBack {
    /**
     * 芯片波段List
     */
    List<Long> tChipWlRankList;
    /**
     * 必用的荧光粉id
     */
    private String mustUsePhosphorId;

    /**
     * 禁止使用的荧光粉的id
     */
    private String prohibitedPhosphorId;

    /**
     * 允许使用的荧光粉类型
     */
    private String limitPhosphorType;
    /**
     * 类型 0：没有要求，1：亮度不符，2：显指不符
     */
    Integer type;
    /**
     * 任务单id
     */
    Integer taskId;
    /**
     * 模型id
     */
    Integer modelId;


}
