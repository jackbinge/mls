package com.wiseq.cn.entity.dataCollection;

import com.wiseq.cn.entity.ykAi.TAiModel;
import lombok.Getter;
import lombok.Setter;
import org.springframework.web.bind.annotation.GetMapping;

@Getter
@Setter
public class CommissioningReal {
    private TAiModel tAiModel;
    private BillParm billParm;
}
