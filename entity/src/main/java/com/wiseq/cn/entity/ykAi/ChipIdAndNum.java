package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/6/13     jiangbailing      原始版本
 * 文件说明:
 */
@Data
public class ChipIdAndNum {
    private Long chipId;
    private Integer chipNum;

    public ChipIdAndNum(Long chipId, Integer chipNum) {
        this.chipId = chipId;
        this.chipNum = chipNum;
    }

    public ChipIdAndNum() {
    }

    @Override
    public String toString() {
        return "ChipIdAndNum{" +
                "chipId=" + chipId +
                ", chipNum=" + chipNum +
                '}';
    }
}
