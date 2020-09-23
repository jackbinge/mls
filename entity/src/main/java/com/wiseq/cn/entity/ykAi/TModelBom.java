package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/10      jiangbailing      原始版本
 * 文件说明:基础库-生产搭配所需数据
 */
@Data
public class TModelBom {
    /**
     * 模型对应的BOMlist 包含对应的芯片波段
     */
    private  Long id;
    /**
     * 模型ID
     */
    private  Long modelId;
    /**
     * bomID
     */
    private Long bomId;
    /**
     * 芯片波段ID
     */
   /* private  Long chipWlRankId;*/



}
