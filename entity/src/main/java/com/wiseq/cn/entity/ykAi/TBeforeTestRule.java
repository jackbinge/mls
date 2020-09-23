package com.wiseq.cn.entity.ykAi;


import lombok.Data;

import java.io.Serializable;

/**
 * t_before_test_rule
 * @author
 */
@Data
public class TBeforeTestRule implements Serializable {
    private Long id;

    /**
     * 规则类型， 0 椭圆,1 四边形,2 点,3 等于出货要求中心点，该中心点在在新建机种时，以调用算法算出来
     */
    private Byte ruleKind;

    /**
     * 椭圆长轴
     */
    private Double a;

    /**
     * 椭圆短轴
     */
    private Double b;

    /**
     * 椭圆中心点x
     */
    private Double x;

    /**
     * 椭圆中心点y
     */
    private Double y;

    /**
     * 椭圆倾角
     */
    private Double angle;

    /**
     * 左上-坐标 x1
     */
    private Double x1;

    /**
     * 左上-坐标 y1
     */
    private Double y1;

    /**
     * 右上-坐标 x2
     */
    private Double x2;

    /**
     * 右上-坐标 y2
     */
    private Double y2;

    /**
     * 右下-坐标 x3
     */
    private Double x3;

    /**
     * 右下下-坐标 y3
     */
    private Double y3;

    /**
     * 左下-坐标 x4
     */
    private Double x4;

    /**
     * 左下-坐标 y4
     */
    private Double y4;

    /**
     * 中心点x
     */
    private Double cpX;

    /**
     * 中心点x
     */
    private Double cpY;

}
