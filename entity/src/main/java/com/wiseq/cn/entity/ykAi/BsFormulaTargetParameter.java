package com.wiseq.cn.entity.ykAi;

import lombok.Data;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/15     jiangbailing      原始版本
 * 文件说明:
 */
@Data
public class BsFormulaTargetParameter {
    private  Double raTarget;
    private  Double   raMax;
    private  Double     raMin;
    private  Double r9 ;
    private  Double ct;
    private   Double   lumenLsl;
    private   Double  lumenUsl;
    private    Double  wlLsl ;
    private    Double    wlUsl;
    private    Long bsFormulaUpdateLogId;
}
