package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.entity.ykAi.AiDadainRatio;
import com.wiseq.cn.entity.ykAi.TPhosphor;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:  原材料库-荧光粉
 */
public interface TPhosphorDao {

    int insert(TPhosphor record);

    List<TPhosphor> findExistList(@Param("phosphorSpec")String phosphorSpec);

    int update(TPhosphor tPhosphor);

    int updateDisabled(TPhosphor tPhosphor);

    int updateDel(TPhosphor tPhosphor);

    AiDadainRatio getPhSpec(long specId);

    List<TPhosphor> findList(@Param("phosphorSpec")String phosphorSpec,
                             @Param("disabled")Boolean disabled,
                             @Param("phosphorType")String phosphorType,
                             @Param("phosphorTypeId") Integer phosphorTypeId);
}