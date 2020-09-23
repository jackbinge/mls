package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/5     lipeng      原始版本
 * 文件说明:  设备阀体表
 */
@Data
public class TEqptValve {
    private Long id;

    /**
    * 阀体名称
    */
    private String name;

    /**
     * 备注
     */
    private String remark;

    /**
     * 设备ID
     */
    private Long eqptId;

    /**
     * false删除true保留
     */
    private Boolean isDelete;

}