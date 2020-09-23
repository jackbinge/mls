package com.wiseq.cn.entity.webview;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;

/**
 * 版本        修改时间        作者        修改内容
 * V1.0        ------        songlp       原始版本
 * 文件说明: 数据导入导出记录
 **/
@Getter
@Setter
public class DataOperateRecord {
//    public DataOperateRecord(String fileName, Integer operator, Date operateTime, Integer type, String route) {
//        this.fileName = fileName;
//        this.operator = operator;
//        this.operateTime = operateTime;
//        this.type = type;
//        this.route = route;
//    }
    private Integer id;
    private String fileName;//文件名
    private Integer operator;//操作人
    private String operatorName;//操作人姓名
    private Date operateTime;//操作时间
    private Integer type;//操作类型
    private String route;//菜单路由
    private String startTime;//导入开始时间
    private String endTime;//导入结束时间
    private Integer isDeleted;//删除标识[0-正常，1-删除]

}
