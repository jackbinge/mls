package com.wiseq.cn.ykAi.service.serviceimpl;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.entity.ykAi.TDiffusionPowder;
import com.wiseq.cn.utils.PageUtil;
import com.wiseq.cn.ykAi.dao.TDiffusionPowderDao;
import com.wiseq.cn.ykAi.service.TDiffusionPowderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/30       lipeng      原始版本
 * 文件说明:  原材料库-扩散粉
 */
@Service
public class TDiffusionPowderServiceImpl implements TDiffusionPowderService {

    @Autowired
    TDiffusionPowderDao tDiffusionPowderMapper;

    /**
     * 扩散粉新增
     * @param tDiffusionPowder
     * @return
     */
    @Override
    public int insert(TDiffusionPowder tDiffusionPowder) {
        if (null == tDiffusionPowder.getDiffusionPowderSpec()) {
            return ResultEnum.DiffusionPowderSpec.getState();
        }
        if (null == tDiffusionPowder.getDensity()) {
            return ResultEnum.Density_k.getState();
        }
        if (null == tDiffusionPowder.getAddProportion()) {
            return ResultEnum.AddProportion_k.getState();
        }
        //对扩散粉规格做重复性校验
        List<TDiffusionPowder> existList = tDiffusionPowderMapper.findExistList(tDiffusionPowder.getDiffusionPowderSpec());
        if (existList.size()>0) {
            return ResultEnum.tDiffusionPowder.getState();
        }

        int flag = tDiffusionPowderMapper.insert(tDiffusionPowder);
        return flag;
    }
    /**
     * 扩散粉修改
     * @param tDiffusionPowder
     * @return
     */
    @Override
    public int update(TDiffusionPowder tDiffusionPowder) {
        if (null == tDiffusionPowder.getDiffusionPowderSpec()) {
            return ResultEnum.DiffusionPowderSpec.getState();
        }
        if (null == tDiffusionPowder.getDensity()) {
            return ResultEnum.Density_k.getState();
        }
        if (null == tDiffusionPowder.getAddProportion()) {
            return ResultEnum.AddProportion_k.getState();
        }
        //对扩散粉规格做重复性校验
        List<TDiffusionPowder> existList = tDiffusionPowderMapper.findExistList(tDiffusionPowder.getDiffusionPowderSpec());
        if (null != existList) {
            for (TDiffusionPowder item : existList) {
                if (!item.getId().equals(tDiffusionPowder.getId())
                ) {
                    return ResultEnum.tDiffusionPowders.getState();
                }
            }
        }
        int flag = tDiffusionPowderMapper.update(tDiffusionPowder);
        return flag;
    }
    /**
     * 启用禁用
     * @param tDiffusionPowder
     * @return
     */
    @Override
    public int updateDisabled(TDiffusionPowder tDiffusionPowder) {
        int flag = tDiffusionPowderMapper.updateDisabled(tDiffusionPowder);
        return flag;
    }
    /**
     * 逻辑删除
     * @param tDiffusionPowder
     * @return
     */
    @Override
    public int updateDel(TDiffusionPowder tDiffusionPowder) {
        int flag = tDiffusionPowderMapper.updateDel(tDiffusionPowder);
        return flag;
    }

    /**
     * 列表查询
     * @param diffusionPowderSpec
     * @param disabled
     * @param pageNum
     * @param pageSize
     * @return
     */
    @Override
    public PageInfo findList(String diffusionPowderSpec, Boolean disabled, Integer pageNum, Integer pageSize) {
        if (null == pageNum) {
            pageNum = 1;
        }
        if (null == pageSize) {
            pageSize = 30;
        }
        PageUtil.pageHelper(pageNum, pageSize);
        List<TDiffusionPowder> tChipList = tDiffusionPowderMapper.findList(diffusionPowderSpec,disabled);
        PageInfo pageInfo = new PageInfo(tChipList);
        return pageInfo;
    }
}
