package com.wiseq.cn.ykAi.dao;

import com.wiseq.cn.entity.ykAi.TEqpt;
import com.wiseq.cn.entity.ykAi.TEqptValve;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/5     lipeng      原始版本
 * 文件说明:
 */
public interface TEqptMapper {
    int deleteByPrimaryKey(Long id);

    int insertSelective(TEqpt record);

    int updateByPrimaryKeySelective(TEqpt record);

    int updateByPrimaryKey(TEqpt record);


    //校验资产编码
    String findTEqptAssetsCodeExist(@Param("assetsCode") String assetsCode, @Param("id") Long id);

    //位置编码验证
    List<TEqpt> findTEqptExistPositon(@Param("positon") Integer positon, @Param("groupId") Long groupId, @Param("id") Long id);

    /**
     * 删除
     *
     * @param id
     * @return
     */
    int updateDel(@Param("id") Long id);

    List<TEqpt> findList(@Param("groupId") Long groupId, @Param("positon") String positon, @Param("assetsCode") String assetsCode, @Param("disabled") Boolean disabled);

    /**
     * 启用禁用
     *
     * @param eqptId
     * @return
     */
    int updateToDisable(@Param("eqptId") Long eqptId, @Param("disable") Boolean disable);




//    List<TEqptValve> findTeqptValveList(Integer eqptId);
}