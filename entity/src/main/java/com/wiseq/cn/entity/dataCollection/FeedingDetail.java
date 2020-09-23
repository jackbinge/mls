package com.wiseq.cn.entity.dataCollection;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class FeedingDetail {

    //机种名称
    private String productName;
    private List<Chip> chip;
    private List<Glue> glue;
    //支架
    private List<Scaffold> scaffold;
    //抗沉淀分
    private List<AntiAtarch> antiAtarche;
    //扩散粉
    private List<DiffusionPowder> diffusionPowder;
    //荧光粉
    private List<Phosphor> phosphor;
    //是否异常
    private Integer type;
    //异常原因
    private List<String> reason;

}
