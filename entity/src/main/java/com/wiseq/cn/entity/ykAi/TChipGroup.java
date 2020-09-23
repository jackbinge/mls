package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/28       lipeng      原始版本
 * 文件说明:  原材料库-芯片编辑
 */
@Data
public class TChipGroup {
    /**
     * 设备
     */
    private TChip tChip;

    /**
     * 波段新增的List
     */
    private List<TChipWlRank> tChipWlRankInsertList;

    /**
     * 波段修改的List
     */
    private List<TChipWlRank> tChipWlRankUpdateList;

    /**
     * 波段删除的List
     */
    private List<TChipWlRank> tChipWlRankDelList;
}