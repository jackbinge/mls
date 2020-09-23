package com.wiseq.cn.entity.ykAi;

import java.util.Date;

import lombok.Builder;
import lombok.Data;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/31       lipeng      原始版本
 * 文件说明:  原材料库-胶水比例表
 */
@Data
public class TGlue {
    private Long id;

    /**
    * 固定比例a
    */
    private Double ratioA;

    /**
    * 固定比例b
    */
    private Double ratioB;

    /**
    * 创建时间
    */
    private Date createTime;

    /**
     * false 正常、true 删除
     */
    private Boolean isDelete;

    /**
     * false 不禁用 true 禁用
     */
    private Boolean disabled;

}