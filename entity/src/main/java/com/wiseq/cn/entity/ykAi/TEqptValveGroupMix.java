package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/5     lipeng      原始版本
 * 文件说明:点胶设备编辑
 */
@Data
public class TEqptValveGroupMix {

    /**
     * 设备
     */
    private TEqpt eqpt;

    /**
     * 新增list
     */
    private List<TEqptValve> tEqptValveInsert;

    /**
     * 修改list
     */
    private List<TEqptValve> tEqptValveUpdate;

    /**
     * 删除list
     */
    private List<TEqptValve> tEqptValveDel;

}
