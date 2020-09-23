package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.Date;
import java.util.List;
/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/12      jiangbailing      原始版本
 * 文件说明:基础库-修改日志
 */
@Data
public class BsFormulaUpdateLongPage {
    private Long bsFormulaUpdateLongId;
    /**
     * 修改人
     */
    private String username;

    /**
     * 修改类型
     */
    private Byte updateType;

    /**
     * 修改名字
     */
    private String updateName;

    /**
     * 创建时间
     */
    private Date createTime;
    /**
     * 配方id
     */
    private Long modelBomId;
    /**
     * A 胶
     */
    private TMaterialFormula glueA;



    /**
     * B 胶
     */
    private TMaterialFormula glueB;



    /**
     * 荧光粉
     */
    private List<TMaterialFormula> tPhosphors;


    /**
     *抗沉淀粉
     */
    private TMaterialFormula antiStarch;


    /**
     * 扩散粉
     */
    private TMaterialFormula diffusionPowder;

}
