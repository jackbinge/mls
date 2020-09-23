package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/25     jiangbailing      原始版本
 * 文件说明:
 */
@Data
public class BsEqptValveDosageEadit {
    private  Long userId;
    private List<BsEqptGuleDosage> bsEqptGuleDosageList;
}
