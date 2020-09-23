package com.wiseq.cn.entity.ykAi;

import java.util.Date;
import java.util.List;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/6     lipeng      原始版本
 * 文件说明:  色区
 */
@Data
public class TColorRegion {
    private Long id;

    /**
    * 机种id
    */
    private Long typeMachineId;

    /**
    * 色区名称，色块色区名称
    */
    private String name;

    /**
    * 色区细分类型，0 色容差色区，1 色块色区
    */
    private Byte colorRegionType;

    /**
    * 此色块所在行数, 只针对色块色区，色容差色区该字段为空
    */
    private Integer xrows;

    /**
    * 此色块所在列数，只针对色块色区，色容差色区该字段为空
    */
    private Integer xcolumns;

    /**
    * 创建时间
    */
    private Date createTime;

    /**
    * false、true 删除
    */
    private Boolean isDelete;

    /**
    * false启用、true 禁用
    */
    private Boolean disabled;

    /**
     * 色区详情表
     */
    private List<TColorRegionDtl> tColorRegionDtl;
}