package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/11/5       lipeng      原始版本
 * 文件说明:  点胶页面数据接收对象
 */
@Data
public class TEqptValveGroup {
    /**
     * 设备
     */
    private TEqpt tEqpt;

    /**
     * 阀体
     */
    private List<TEqptValve> tEqptValveList;


}