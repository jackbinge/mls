package com.wiseq.cn.utils;

import com.wiseq.cn.entity.ykAi.BsEqptGuleDosage;
import com.wiseq.cn.service.UserOrder;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.TreeSet;
import java.util.stream.Collectors;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/12/3     jiangbailing      原始版本
 * 文件说明:
 */
public class BsEqptGuleDosage_DISTINCT {
    public static List<BsEqptGuleDosage> distinctMethod(List<BsEqptGuleDosage> list){
        System.out.println("=====>同时根据taskStateId和eqptValveId两个属性进行去重");
        ArrayList<BsEqptGuleDosage> distinctByEqptValveIdAndTaskStateId = list.stream()
                .collect(
                        Collectors.collectingAndThen(
                                Collectors.toCollection(() -> new TreeSet<>(Comparator.comparing(bsEqptGuleDosage ->  bsEqptGuleDosage.getEqptValveId() + bsEqptGuleDosage.getTaskStateId()))),
                                ArrayList::new
                        )
                );
        distinctByEqptValveIdAndTaskStateId.forEach(System.out::println);
        return  distinctByEqptValveIdAndTaskStateId;
    }
}
