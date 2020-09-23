package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/20     jiangbailing      原始版本
 * 文件说明: 算法返回的你和中心点
 */
@Data
public class AiCenterPoint {
    /**
     * 中心点x坐标
     */
    private Double center_x;
    /**
     * 中心点y坐标
     */
    private Double center_y;
}
