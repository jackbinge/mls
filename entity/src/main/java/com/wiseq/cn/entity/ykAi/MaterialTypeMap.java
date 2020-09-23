package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/8     lipeng      原始版本
 * 文件说明:  
 */
@Data
public class MaterialTypeMap {
    private Long id;

    /**
     * 物料类型，0芯片  1胶水 2 荧光粉 3 支架 4扩散粉 5抗沉淀粉
     */
    private Byte materalType;

    /**
    * 物料类型名
    */
    private String typeName;

    /**
    * 物料编码与类型映射规则，建议为正则表达式,通过正则过滤
    */
    private String mapRule;

    /**
    * 备注
    */
    private String remark;

    /**
    * 是否禁用 false 不禁用 true 禁用
    */
    private Boolean disabled;

    /**
    * false正常、true 删除
    */
    private Boolean isDelete;
}