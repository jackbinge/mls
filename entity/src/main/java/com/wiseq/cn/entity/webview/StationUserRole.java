package com.wiseq.cn.entity.webview;

import com.wiseq.cn.entity.annotations.QuIndex;
import lombok.Getter;
import lombok.Setter;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: 岗位对应规则entity
 **/
@Getter
@Setter
public class StationUserRole {
    @QuIndex
    private Integer id;
    @QuIndex
    private Integer userId;
    @QuIndex
    private Integer stationId;
    private Integer isdeleted;

}
