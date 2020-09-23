package com.wiseq.cn.entity.ykAi;

import java.util.Date;
import java.util.List;

import lombok.Data;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/30       lipeng      原始版本
 * 文件说明:  原材料库-支架
 */
@Data
public class TScaffold {
    private Long id;

    /**
    * 支架编码
    */
    private String scaffoldCode;

    /**
    * 支架规格
    */
    private String scaffoldSpec;

    /**
    * 供应商
    */
    private String supplier;

    /**
    * 产品系列
    */
    private String family;

    /**
    * 是棱台还是圆台。棱台默认使用1-5到 分别是底宽、底长、顶长、顶宽、和高；圆台使用1-3，分别是底部直径，顶部直径，高度
    */
    private Byte isCircular;

    /**
    * 棱台底宽/底部直径
    */
    private Double param1;

    /**
    * 棱台底长/顶部直径
    */
    private Double param2;

    /**
    * 棱台顶长/圆台高度
    */
    private Double param3;

    /**
    * 棱台顶宽
    */
    private Double param4;

    /**
    * 棱台高
    */
    private Double param5;

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