package com.wiseq.cn.entity.ykAi;

import lombok.Data;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Date;
import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/6      jiangbailing      原始版本
 * 文件说明:基础库-机种库-出货要求
 */
@Data
public class TOutputRequirementsAll {
    /**
     * 新增列表
     */
   private List<TOutputRequirements> addList;
    /**
     * 修改的列表
     */
   private List<TOutputRequirements> updateList;
    /**
     * 删除的列表
     */
   private List<TOutputRequirements> deleteList;
    /**
     * 显色指数上限
     */
   private  Double raMax;
    /**
     * 显色指数下线
     */
   private  Double raMin;

    /**
     * 机种ID
     */
   private  Long typeMachineId;
}
