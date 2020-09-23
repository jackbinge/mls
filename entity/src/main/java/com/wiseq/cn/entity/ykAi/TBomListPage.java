package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;
/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/11      jiangbailing      原始版本
 * 文件说明:基础库-bom页面展示用
 */

@Data
public class TBomListPage {
    /**
     *bom中荧光粉个数
     */
    private Integer maxLength;

    /**
     * bom列表
     */
    List<TBom> tBoms;
}
