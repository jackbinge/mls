package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/20     jiangbailing      原始版本
 * 文件说明:  SPC规则判断接口 data结果
 *
 * (1)若控制点为△x，△y，
 * 则points_infos_x,points_infos_y,cl_infos_x,cl_infos_y
 */
@Data
public class AiSpecRule {
    private AiSpecPointInfo points_infos;
    private AiSpecClInfos cl_infos;
    private AiSpecPointInfo points_infos_x;
    private AiSpecPointInfo points_infos_y;
    private AiSpecClInfos cl_infos_x;
    private AiSpecClInfos cl_infos_y;

}
