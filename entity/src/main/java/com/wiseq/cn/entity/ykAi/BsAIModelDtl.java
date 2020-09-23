package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/25     jiangbailing      原始版本
 * 文件说明:
 */
@Data
public class BsAIModelDtl {
    /**
     * 搭配ID
     */
    private Long modelId;

    /**
     * 机种ID
     */
    private Long typeMachineId;
    /**
     * 出货要求ID
     */
    private Long outputRequireMachineId;

    /**
     * 是否删除
     */
    private Boolean isDelete;

    /**
     * 色区ID
     */
    private Long colorRegionId;

    /**
     * 工艺类型
     */
    private Byte processType;

    /**
     * bomId
     */
    private Long bomId;

    /**
     * 芯片波段ID
     */
    private Long chipWlRankId;
}
