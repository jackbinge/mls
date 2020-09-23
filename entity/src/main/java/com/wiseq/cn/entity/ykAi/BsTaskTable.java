package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/17     jiangbailing      原始版本
 * 文件说明:
 */
@Data
public class BsTaskTable {
    private Long  id;
    private String taskCode;//工单编码
    private Integer type;//工单类型，0量产，1试样
    private Long woId;//EAS工单表主键
    private Integer state;//工单是否关闭 1 ture关闭 0 false未关闭
    private String createTime;//建立时间
    private String closeTime;//关闭时间
    private Integer raR9Type;//是否忽略RaR9
}
