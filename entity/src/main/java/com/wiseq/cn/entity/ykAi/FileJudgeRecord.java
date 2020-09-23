package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;
import java.util.Map;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/6/1     jiangbailing      原始版本
 * 文件说明:
 */
@Data
public class FileJudgeRecord {
    private String judgeTime;//判定时间
    private String judgeUser;//判定人
    private String fileState;//-1 未判定，0判定ok,1判定NG
    private String judgeType;//0 正常判定为OK，1改判为OK,2强制通过为OK
    private String fileIdList;//分光文件列表
    private List<Map<String,Object>> testInfo;//测试数据· 测试人和测试时间
}
