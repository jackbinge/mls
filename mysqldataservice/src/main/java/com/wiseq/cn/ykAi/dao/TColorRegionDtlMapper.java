package com.wiseq.cn.ykAi.dao;


import com.wiseq.cn.entity.ykAi.FkInfoDTO;
import com.wiseq.cn.entity.ykAi.SKInfoDTO;
import com.wiseq.cn.entity.ykAi.TColorRegionDtl;
import com.wiseq.cn.entity.ykAi.TyInfoDTO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/6     lipeng      原始版本
 * 文件说明:  色区明细
 */
public interface TColorRegionDtlMapper {


    int insertSelective(TColorRegionDtl tColorRegionDtl);

    TColorRegionDtl selectByPrimaryKey(@Param("colorRegionId") Long colorRegionId, @Param("name") String name, @Param("shape") Byte shape);

    void update(TColorRegionDtl tColorRegionDtl);

    List<TColorRegionDtl> findExist(@Param("name") String name, @Param("colorRegionId") Long colorRegionId);

    int updateSkBatch(@Param("list") List<SKInfoDTO> skInfoDTOS);

    /**
     * 修改椭圆
     * @param tyInfoDTO
     * @return
     */
    int updateTy(TyInfoDTO tyInfoDTO);

    /**
     * 修改方块
     * @param fkInfoDTO
     * @return
     */
    int updateFk(FkInfoDTO fkInfoDTO);
}