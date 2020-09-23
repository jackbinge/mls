package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2020/9/9    zhujiabin      原始版本
 * 文件说明:耗用
 */
@Data
public class StartAdvice implements Serializable{

        //需要推荐配比的模型ID
        private Long modelId;

        //任务单状态id
        private Long taskStateId;

        //显指偏高还是偏低   0 适中，1偏高，2偏低
        private Long raHOrL;


        //显指调整比例
        private Double raRatio;
        //微调
        private Double wt;
        //打点坐标   以-组合成字符串发给我
        private String points;

        //a胶耗用
        private Double glueAMaterial;

        //b胶耗用
        private Double glueBMaterial;

}
