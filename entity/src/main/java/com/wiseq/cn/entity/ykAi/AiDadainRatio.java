package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.lang.reflect.Array;
import java.util.List;
import java.util.Map;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/9/10     zhujiabin      原始版本
 * 文件说明: 算法返回的推荐种类和推荐配比
 */
@Data
public class AiDadainRatio implements Comparable<AiDadainRatio>{



    //private Long tphSpecId;

    private Long materialId;

    private String spec;

    private Double peakWavelength;

    private Double ratio;

    public int compareTo(AiDadainRatio o) {
        Double i = this.getRatio() - o.getRatio();
        int px = 1;
        if(i >= 0){
            return px;
        }else{
            px = -1;
            return px;
        }

    }
}
