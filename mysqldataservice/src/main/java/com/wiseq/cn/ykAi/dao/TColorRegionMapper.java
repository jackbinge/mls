package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.entity.ykAi.QuadrilateralDTO;
import com.wiseq.cn.entity.ykAi.TColorRegion;
import com.wiseq.cn.entity.ykAi.TColorRegionMix;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/6     lipeng      原始版本
 * 文件说明:  色区
 */
public interface TColorRegionMapper {


    List<TColorRegionMix> findList(@Param("spec") String spec, @Param("processType") Byte processType);

    List<TColorRegion> findExist(@Param("name") String name,
                                 @Param("colorRegionType") Byte colorRegionType,
                                 @Param("typeMachineId") Long typeMachineId);

    void insert(TColorRegion tColorRegion);

    void update(TColorRegion tColorRegion);

    /**
     * 椭圆
     * @param typeMachineId
     * @param a
     * @param b
     * @param x
     * @param y
     * @param angle
     * @return
     */
    Integer findExistColorRegionEllipse(@Param("typeMachineId") Long typeMachineId,
                                          @Param("a") Double a,
                                          @Param("b") Double b,
                                          @Param("x") Double x,
                                          @Param("y") Double y,
                                          @Param("angle") Double angle);

    /**
     * 四边形
     * @param typeMachineId
     * @return
     */
    List<QuadrilateralDTO> findExistColorRegionQuadrilateral(@Param("typeMachineId") Long typeMachineId);
}