package com.wiseq.cn.entity.ykAi;


import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/18     jiangbailing      原始版本
 * 文件说明:
 */
@Data
public class TBomMaterial {
    private Long bomId;
    private Long materialId;
    private Integer materialType;//物料类型，0芯片  1胶水 2 荧光粉 3 支架 4扩散粉 5抗沉淀粉
}
