package com.wiseq.cn.ykAi.service.serviceimpl;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.entity.ykAi.TScaffold;
import com.wiseq.cn.utils.PageUtil;
import com.wiseq.cn.ykAi.dao.TScaffoldDao;
import com.wiseq.cn.ykAi.service.TScaffoldService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/9/10       lipeng      原始版本
 * 文件说明:原材料库-支架
 */
@Service
public class TScaffoldServiceImpl implements TScaffoldService {
    @Autowired
    TScaffoldDao tScaffoldMapper;

    /**
     * 原材料库-芯片-新增芯片信息
     *
     * @param tScaffold
     * @return
     */
    @Override
    public int insert(TScaffold tScaffold) {

        if (null == tScaffold.getScaffoldSpec()) {
            return ResultEnum.ScaffoldSpec.getState();
        }
        if (null == tScaffold.getIsCircular()) {
            return ResultEnum.IsCircular.getState();
        }
        //该接口中的尺寸的校验由前端完成
//        if (null == tScaffold.getParam1()) {
//            return ResultEnum.Param1.getState();
//        }
//        if (null == tScaffold.getParam2()) {
//            return ResultEnum.Param2.getState();
//        }
//        if (null == tScaffold.getParam3()) {
//            return ResultEnum.Param3.getState();
//        }
        //对芯片规格做重复性校验
        List<TScaffold> existList = tScaffoldMapper.findExistList(tScaffold.getScaffoldSpec(),tScaffold.getId());
        if (existList.size()>0) {
            return ResultEnum.tScaffold.getState();
        }

        int flag = tScaffoldMapper.insert(tScaffold);
        return flag;
    }

    /**
     * 原材料库-芯片-修改芯片信息
     *
     * @param tScaffold
     * @return
     */
    @Override
    public int update(TScaffold tScaffold) {
        if (null == tScaffold.getScaffoldSpec()) {
            return ResultEnum.ScaffoldSpec.getState();
        }
        if (null == tScaffold.getIsCircular()) {
            return ResultEnum.IsCircular.getState();
        }
        //对芯片规格做重复性校验
        List<TScaffold> existList = tScaffoldMapper.findExistList(tScaffold.getScaffoldSpec(),tScaffold.getId());
        if (existList.size()>0) {
//            for (TScaffold item : existList) {
//                if (!item.getId().equals(tScaffold.getId())
//                ) {
                    return ResultEnum.tScaffolds.getState();
//                }
//            }
        }
        int flag = tScaffoldMapper.update(tScaffold);
        return flag;
    }

    //查询芯片信息主列表
    @Override
    public PageInfo findList(String scaffoldSpec, Boolean disabled, Integer pageNum, Integer pageSize,Byte scaffoldType) {
        if (null == pageNum) {
            pageNum = 1;
        }
        if (null == pageSize) {
            pageSize = 30;
        }
        PageUtil.pageHelper(pageNum, pageSize);
        List<TScaffold> tScaffoldList = tScaffoldMapper.findList(scaffoldSpec,disabled,scaffoldType);
        PageInfo pageInfo = new PageInfo(tScaffoldList);
        return pageInfo;
    }

    /**
     * 原材料库-芯片-启用禁用
     *
     * @param tScaffold
     * @return
     */
    @Override
    public int updateDisabled(TScaffold tScaffold) {
        int flag = tScaffoldMapper.updateDisabled(tScaffold);
        return flag;
    }

    /**
     * 原材料库-芯片-逻辑删除
     *
     * @param tScaffold
     * @return
     */
    @Override
    public int updateDel(TScaffold tScaffold) {
        int flag = tScaffoldMapper.updateDel(tScaffold);
        return flag;
    }

}
