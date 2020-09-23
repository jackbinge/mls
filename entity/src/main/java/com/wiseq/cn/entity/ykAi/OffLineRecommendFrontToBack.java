package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/22     jiangbailing      原始版本
 * 文件说明: 再现推bom时前台传后台
 */
@Data
public class OffLineRecommendFrontToBack {
    List<Long> chipIdList;
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
     * 胶水id
     */
    private Long glueId ;
    /**
     * 扩散粉
     */
    private Long diffusionPowderId ;
    private Long scaffoldId ;//支架
    private Long antiStarchId ;//坑沉淀粉

    private Integer typeMachineId;

}
