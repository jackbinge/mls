package com.wiseq.cn.entity.ykAi;

import java.util.Date;
import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/8     lipeng      原始版本
 * 文件说明:  用户角色
 */
@Data
public class TRole {
    private Long id;

    private Long groupId;

    private String name;

    private String remark;

    private Boolean disabled;


    /**
    * 创建时间
    */
    private Date createTime;
}