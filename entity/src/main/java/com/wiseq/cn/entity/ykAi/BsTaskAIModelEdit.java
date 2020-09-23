package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;


/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/25     jiangbailing      原始版本
 * 文件说明: 工单配比修改接口
 */
@Data
public class BsTaskAIModelEdit {
    /**
     * BOMId
     */
    private Long bomId;

    /**
     * 芯片波段
     */
//    private Long chipWlRankId;
    private List<Long> chipWlRankIdList;
    /**
     * 工单Id
     */
    private Long taskId;
    /**
     * 工单状态ID
     */
    private Long taskStateId;

    /**
     * 用户ID
     */
    private Long userId;
}
