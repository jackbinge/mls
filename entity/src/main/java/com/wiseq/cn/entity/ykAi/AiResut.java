package com.wiseq.cn.entity.ykAi;

import com.alibaba.fastjson.JSONObject;
import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/20     jiangbailing      原始版本
 * 文件说明:算法结果统一类
 */
@Data
public class AiResut {
    //code
    private Integer code;
    //描述
    private String msg;
    //返回的object
    JSONObject data;
}
