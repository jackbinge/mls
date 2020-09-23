package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/20     jiangbailing      原始版本
 * 文件说明:
 */
@Data
public class AiSpecPointInfo {
    /**
     * 点的坐标
     */
   private Double point;
    /**
     * label:1违反规则，0未违反规则
     */
   private Byte label;

    /**
     * 违反的规则ID
     */
   private List<Long> reason;



}
