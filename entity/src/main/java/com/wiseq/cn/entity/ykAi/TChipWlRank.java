package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:  原材料库-芯片波段
 */
@Data
public class TChipWlRank {
    private Long id;

    /**
     * 芯片波段名字
     */
    private String name;

    /**
     * 芯片ID
     */
    private Long chipId;

    /**
     * 波长最大值
     */
    private Double wlMax;

    /**
     * 波长最小值
     */
    private Double wlMin;

    /**
     * false正常、true 删除
     */
    private Boolean isDelete;

    //对象比较
    @Override
    public boolean equals(Object obj) {
        TChipWlRank tChipWlRank = (TChipWlRank) obj;
        if(this.getChipId() != tChipWlRank.getChipId()){
            return false;
        }
        if(!this.getName().equals(tChipWlRank.name)){
            return false;
        }
        if(!this.getWlMax().equals(tChipWlRank.getWlMax())){
            return false;
        }
        if(!this.getWlMin().equals(tChipWlRank.getWlMin())){
            return false;
        }
        return true;
    }
}