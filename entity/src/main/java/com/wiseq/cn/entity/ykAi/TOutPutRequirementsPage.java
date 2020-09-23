package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;

/**
 * 出货要求列表展示数据
 */
@Data
public class TOutPutRequirementsPage {
    /**
     * 出货要求
     */
    private TOutputRequirements tOutputRequirements;

    /**
     * 出货比例类型
     */
    private List<TOutPutRequirementsColorSK> skList;

    /**
     * 色区或色容差
     */
    private TOutPutRequirementsColorRegion colorRegion;
}
