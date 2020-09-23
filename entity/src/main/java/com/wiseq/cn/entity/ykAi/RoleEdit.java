package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/14      jiangbailing      原始版本
 * 文件说明:后他管理-角色对应的权限
 */
@Data
public class RoleEdit {
    /**
     * 编辑/新增的角色
     */
    private TRole tRole;

    /**
     * 角色对应的权限
     */
    List<Long> privileges;
}
