package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/8      jiangbailing      原始版本
 * 文件说明:基础库-SPC页面展示
 */
@Data
public class TSpcRuleMix {
    /**
     * spc指控表/新增时要穿
     */
    private TSpcRule tSpcRule;
    /**
     * spc模板
     */
    private List<TSpcBaseRule> tSpcBaseRules;

    /**
     * spc实际表/新增时要传
     */
    private List<TSpcRuleDtl> tSpcRuleDtls;

}
