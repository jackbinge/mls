package com.wiseq.cn.entity.ykAi;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.wiseq.cn.entity.webview.Department;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/11     lipeng      原始版本
 * 文件说明:
 */
@Data
public class TGroup {
    private Long id;

    /**
     * 父ID
     */
    private Long parentId;

    /**
     * 编码
     */
    private String code;

    /**
     * 组织名称
     */
    private String name;

    /**
     * 关联至eas组织结构id
     */
    private String mapEasId;

    /**
     * 父级路径
     */
    private String parentPath;

    /**
     * 组织级别,建议创建一张表，关联相关id
     */
    private String level;

    /**
     * true 已删除；false 未删除
     */
    private Boolean isDelete;

    /**
     * 创建时间
     */
    private Date createTime;
//    @ApiModelProperty(hidden = true)
    private List<TGroup> children = new ArrayList<TGroup>();
}