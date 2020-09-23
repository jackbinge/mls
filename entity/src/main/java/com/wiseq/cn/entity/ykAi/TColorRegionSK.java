package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/6      jiangbailing      原始版本
 * 文件说明:基础库-色块
 */
@Data
public class TColorRegionSK {
    /**
     * 色区名称
     */
    private String name;

    /**
     * 用户id
     */
    private Long id;

    /**
     * 此色块所在行数, 只针对色块色区，色容差色区该字段为空
     */
    private Integer xrows;

    /**
     * 此色块所在列数，只针对色块色区，色容差色区该字段为空
     */
    private Integer xcolumns;

    /**
     * 删除
     */
    private Boolean isDelete;

    /**
     * 色块信息
     */
    private List<TColorRegionOneSK> lists;





}
