package com.wiseq.cn.entity.webview;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        molei     原始版本
 * 文件说明: Recursion
 **/
@Setter
@Getter
public class Recursion {
    /**
     * 主ID
     */
    private Integer mainId;
    /**
     * 数据编码
     */
    private String id;
    /**
     * label
     */
    private String label;

    /**
     * 等级 0 - 公司 1 - 部门 2 - 角色 3 - 人员
     */
    private int grade;
    /**
     * 子集
     */
    private List<Recursion> children;
}
