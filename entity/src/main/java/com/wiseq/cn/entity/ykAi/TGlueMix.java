package com.wiseq.cn.entity.ykAi;

import lombok.Data;


/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/31       lipeng      原始版本
 * 文件说明:  原材料库-胶水比例
 */
@Data
public class TGlueMix {

    private Long id;
    /**
     * 胶水比例
     */
    private TGlue tGlue;

    /**
     * 胶水详情
     */
    private TGlueDtl tGlueDtl;

}