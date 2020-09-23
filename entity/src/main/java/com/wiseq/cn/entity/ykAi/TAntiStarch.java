package com.wiseq.cn.entity.ykAi;

import java.util.Date;
import lombok.Data;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/30       lipeng      原始版本
 * 文件说明:  原材料库-抗沉淀粉
 */
@Data
public class TAntiStarch {
    private Long id;

    /**
    * 抗沉淀粉编码
    */
    private String antiStarchCode;

    /**
    * 抗沉淀粉规格
    */
    private String antiStarchSpec;

    /**
    * 供应商
    */
    private String supplier;

    /**
    * 密度
    */
    private Double density;

    /**
    * 添加比例
    */
    private Double addProportion;

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