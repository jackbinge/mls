package com.wiseq.cn.entity.ykAi;

import java.util.Date;
import lombok.Data;
/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/12      jiangbailing      原始版本
 * 文件说明:基础库-配比修改日志表
 */
@Data
public class BsFormulaUpdateLog {
    private Long id;

    /**
    * 配方id
    */
    private Long modelBomId;

    /**
    * 1系统推荐，2用户编辑，3生产修正
    */
    private Byte updateType;

    /**
    * 修改用户
    */
    private Long creator;

    /**
    * 创建时间
    */
    private Date createTime;
}