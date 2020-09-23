package com.wiseq.cn.entity.ykAi;

import java.util.Date;
import java.util.List;

import lombok.Data;
/**
 * 版本        修改时间        作者      修改内容
 * V1.0       2019/11/6      jiangbailing      原始版本
 * 文件说明:基础库-机种库-出货要求
 */
@Data
public class TOutputRequirements {
    private Long id;

    /**
    * 机种id
    */
    private Long typeMachineId;

    /**
     * 出货要求编码
     */
    private String code;

    /**
    * 出货要求类型 0 色容差类型，1 出货比例类型，2 中心点类型。其中对于同一机种色容差类型出货要求，共用一组前测规则和非正常烤规则，非色容差出货要求，每种出货要求对应一组前测和非正常烤规则
    */
    private Byte outputKind;

    /**
    * 是否时临时出货要求 true 临时 false 正常
    */
    private Boolean isTemp;

    /**
     * 色容差的只有一条数据
     */
    private List<TOutputRequirementsDtl> tOutputRequirementsDtls;


    /**
    * 创建时间
    */
    private Date createTime;
}