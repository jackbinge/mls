package com.wiseq.cn.entity.webview;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;

/**
 * 版本        修改时间        作者        修改内容
 * V1.0        ------        wangyh       原始版本
 * 文件说明: SysMessage
 **/
@Setter
@Getter
public class SysMessage {
    /** ID **/
    private String id;
    /** 标题 **/
    private String title;
    /** 内容 **/
    private String content;
    /** 类型[0-通知公告   1-异常警告] **/
    private Integer type;
    /** 创建时间-系统自动生成 **/
    @ApiModelProperty(hidden = true)
    private String createTime;
    /** 创建人-系统自动获取 **/
    @ApiModelProperty(hidden = true)
    private Integer creator;
    /** 消息接收人(多人逗号分隔,例：1,2,3,4) **/
    private String userIds;
    @ApiModelProperty(hidden = true)
    /** 是否已读[查询使用,新增不用关注] **/
    private Integer isRead;
    /** 创建人姓名[查询使用,新增不用关注] **/
    @ApiModelProperty(hidden = true)
    private String creatorName;
}
