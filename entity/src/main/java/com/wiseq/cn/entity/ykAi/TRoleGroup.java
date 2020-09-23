package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/12     lipeng      原始版本
 * 文件说明:
 */
@Data
public class TRoleGroup {
    private Long id;

    private Long groupId;

    private String name;

    private String remark;

    private Boolean disable;

    private Boolean isDelete;

    /**
     * 创建时间
     */
    private Date createTime;
    //组织信息部分
    private Long gid;

    /**
     * 编码
     */
    private String gcode;

    /**
     * 组织名称
     */
    private String gname;

    /**
     * 菜单权限id的list
     */
    private List<Long> roleMenuList ;

    /**
     * 按钮权限的id的list
     */
    private List<Long> roleButtonList;
}