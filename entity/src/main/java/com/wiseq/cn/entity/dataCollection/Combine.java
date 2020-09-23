package com.wiseq.cn.entity.dataCollection;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class Combine {
    private Integer typeMachineId;
    private String typeMachineSpec;
    private ScaffoldJudge scaffoldJudge;
    private List<ChipJudge> chipJudge;//芯片的判断
    private List<GlueJudge> glueJudge;
    private List<PhosphorJudge> phosphorJudge;
    private AntiAtarchJudge antiAtarchJudge;
    private DiffusionPowderJudge diffusionPowderJudge;
    private Integer crystalNumber;//晶体数量
}
