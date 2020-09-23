package com.wiseq.cn.entity.ykAi;

import java.util.Date;
import java.util.List;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/5     lipeng      原始版本
 * 文件说明:  
 */
@Data
public class TEqpt {
    private Long id;

    /**
    * 设备编码
    */
    private String eqptCode;

    /**
    * 设备位置编号
    */
    private Integer positon;

    /**
    * 组织架构ID
    */
    private Long groupId;

    /**
    * 针头数量
    */
    private Integer pinheadNum;

    /**
    * 是否禁用 false 不禁用 true 禁用
    */
    private Boolean disabled;

    /**
    * 资产编码
    */
    private String assetsCode;

    /**
    * 设备类型,0 点胶设备
    */
    private Byte type;

    /**
    * 创建时间
    */
    private Date createTime;

    /**
    * false正常、true 删除
    */
    private Boolean isDelete;


    /**
     * 组织名称
     */
    private String name;


    private TGroup tGroup;
    /**
     * 阀体信息
     */
    private List<TEqptValve> tEqptValveList;
}