package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/8     lipeng      原始版本
 * 文件说明:  用户和角色关联表
 */
@Data
public class TUserRole {
    private Long id;

    private Long userId;

    private Long roleId;
}