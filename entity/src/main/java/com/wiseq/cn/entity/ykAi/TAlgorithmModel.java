package com.wiseq.cn.entity.ykAi;


import lombok.Data;

import java.util.List;


/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2020/9/15      zhujiabin      原始版本
 * 文件说明:基础库-生产搭配详情表
 */
@Data
public class TAlgorithmModel {


    private Long id;
    private Long scaffoldId; //'支架id',
    private String scaffoldName; //'支架名称',

    private Double param1;//支架参数1
    private Double param2;
    private Double param3;
    private Double param4;
    private Double param5;
    private String scaffoldParam;  //'支架参数',

    private Double scaffoldRe; // '支架要求',
    private Long chipId; // '芯片id',
    private String chipName;//'芯片名称',

    private Double wlMin;//芯片波长最小值
    private Double wlMax;//芯片波长最大值
    private Long chipWave;//'芯片波长',

    private Long ct;//'色温',
    private Long p1Id;// '粉1id',
    private String p1Name;// '粉1名称',
    private Double p1Wave;//'粉1波长',
    private Long p2Id;//'粉2id',
    private String p2Name;// '粉1名称',
    private Double p2Wave;//'粉2波长',
    private Long p3Id;//'粉3id',
    private String p3Name;// '粉3名称',
    private Double p3Wave;//'粉3波长',

    private List<TMaterialFormula> tPhosphors;

    private Double aRatio;//'A胶比例',
    private Double bRatio;//'B胶比例',
    private Double cRatio;// '沉淀粉比例',
    private Double p1Ratio;// '粉1比例',
    private Double p2Ratio;// '粉2比例',
    private Double p3Ratio;//'粉3比例',

    private Double cieX;//中心点x
    private Double cieY;
    private String centerXy;// '打靶中心',

    private Double raMean;// 'ra均值',
    private Double raMin;// 'ra最小值',
    private Double raMax;//'ra最大值',
    private Double r9Mean;// 'r9均值',
    private Double r9Min;// 'r9最小值',
    private Double r9Max;//'r9最大值',
    private Double lmMean;// '亮度均值',
    private Double lmMin;// '亮度最小值',
    private Double lmMax;//'亮度最大值',
    private String fileName;// '分光文件',
}
