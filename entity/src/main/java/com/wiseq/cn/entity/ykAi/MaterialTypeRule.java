package com.wiseq.cn.entity.ykAi;

import lombok.Data;
/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/13      jiangbailing      原始版本
 * 文件说明:后台管理--物料编码
 */
@Data
public class MaterialTypeRule {
    /**
     * 物料编码与类型映射规则，建议为正则表达式,通过正则过滤
     */
    private String mapRule;
    /**
     * 主键
     */
    private Long id;
    /**
     * 是否禁用 false 不禁用 true 禁用
     */
    private Boolean disabled;

    /**
     * false正常、true 删除
     */
    private Boolean isDelete;

}
