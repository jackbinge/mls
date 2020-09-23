package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/20     jiangbailing      原始版本
 * 文件说明: spec质控信息
 * 若控制线为人工输入，则ab,bc,cb,ba均为None
 */
@Data
public class AiSpecClInfos {
    private Double ucl;
    private Double lcl;
    private Double cl;
    private Double ab;
    private Double bc;
    private Double cb;
    private Double ba;
}
