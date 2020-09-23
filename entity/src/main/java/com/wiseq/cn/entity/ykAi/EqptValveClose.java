package com.wiseq.cn.entity.ykAi;


import lombok.Data;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/24     jiangbailing      原始版本
 * 文件说明:
 */
@Data
public class EqptValveClose {
    /**
     * 工单ID
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
    /**
     * 阀体删除
     */
    private List<Long> eqptValveListDelte;
}
