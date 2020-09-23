package com.wiseq.cn.entity.ykAi;

import java.util.Date;
import lombok.Data;
/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/12      jiangbailing      原始版本
 * 文件说明:基础库-配比库-配比修改日志记录详情表
 */
@Data
public class BsFormulaUpdateLogDtl {
    private Long id;

    /**
    * 配比修改日志
    */
    private Long formulaUpdateLogId;

    /**
    * 配方id - 新加
    */
    private Long modelBomId;

    /**
    * a胶，b胶，荧光粉、抗成淀粉、扩散粉 a胶和b胶对应的胶水详情表 - 新加
    */
    private Long materialId;

    /**
    * 比值 - 新加
    */
    private Double ratio;

    /**
    * 物料类型 0胶A，1胶水B,2 荧光粉，3 抗沉淀粉，4 扩散粉 - 新加
    */
    private Byte materialClass;

    /**
    * 创建时间
    */
    private Date createTime;
}