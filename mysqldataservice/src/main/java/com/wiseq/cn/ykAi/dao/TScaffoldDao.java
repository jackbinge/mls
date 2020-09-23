package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TScaffold;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/28       lipeng      原始版本
 * 文件说明:  原材料库-支架
 */
public interface TScaffoldDao {

    /**
     * 芯片规格重复验证
     * @param scaffoldSpec
     * @param id
     * @return
     */
    List<TScaffold> findExistList(@Param("scaffoldSpec") String scaffoldSpec, @Param("id") Long id);

    int insert(TScaffold tScaffold);

    int update(TScaffold tScaffold);

    List<TScaffold> findList(@Param("scaffoldSpec") String scaffoldSpec,
                             @Param("disabled") Boolean disabled,
                             @Param("scaffoldType") Byte scaffoldType);

    int updateDisabled(TScaffold tScaffold);

    int updateDel(TScaffold tScaffold);
}