package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/13     jiangbailing      原始版本
 * 文件说明:机种设置前端传给后端的实体
 */
@Data
public class TTypeMachineDefaultSetFrontToBack {
    private String limitPhosphorType;//限制的荧光粉类型
    private Integer defaultScaffoldId;//默认的支架
    private Integer defaultGlueId;//默认的胶水
    private Integer defaultDiffusionPowderId;//默认的扩散粉
    private Integer defaultAntiStarchId;//默认抗沉淀粉
    private List<Integer> defalultchip;//默认的芯片
    private Integer   typeMachineId;//机种id

}
