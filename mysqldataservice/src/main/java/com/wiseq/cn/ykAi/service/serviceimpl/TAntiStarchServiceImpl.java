package com.wiseq.cn.ykAi.service.serviceimpl;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.entity.ykAi.TAntiStarch;
import com.wiseq.cn.utils.PageUtil;
import com.wiseq.cn.ykAi.dao.TAntiStarchDao;
import com.wiseq.cn.ykAi.service.TAntiStarchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/30       lipeng      原始版本
 * 文件说明:  原材料库-抗沉淀粉
 */
@Service
public class TAntiStarchServiceImpl implements TAntiStarchService {

    @Autowired
    TAntiStarchDao tAntiStarchMapper;

    /**
     * 新增抗沉淀粉
     * @param tAntiStarch
     * @return
     */
    @Override
    public int insert(TAntiStarch tAntiStarch) {
        if (null == tAntiStarch.getAntiStarchSpec()) {
            return ResultEnum.AntiStarchSpec.getState();
        }
        if (null == tAntiStarch.getDensity()) {
            return ResultEnum.Densitys.getState();
        }
        if (null == tAntiStarch.getAddProportion()) {
            return ResultEnum.AddProportion.getState();
        }
        //对芯片规格做重复性校验
        List<TAntiStarch> existList = tAntiStarchMapper.findExistList(tAntiStarch.getAntiStarchSpec());
        if (existList.size()>0) {
            return ResultEnum.AntiStarchSpecs.getState();
        }

        int flag = tAntiStarchMapper.insert(tAntiStarch);
        return flag;
    }

    /**
     * 修改抗沉淀粉
     * @param tAntiStarch
     * @return
     */
    @Override
    public int update(TAntiStarch tAntiStarch) {
        if (null == tAntiStarch.getAntiStarchSpec()) {
            return ResultEnum.AntiStarchSpec.getState();
        }
        if (null == tAntiStarch.getDensity()) {
            return ResultEnum.Densitys.getState();
        }
        if (null == tAntiStarch.getAddProportion()) {
            return ResultEnum.AddProportion.getState();
        }
        //对抗沉淀粉规格做重复性校验
        List<TAntiStarch> existList = tAntiStarchMapper.findExistList(tAntiStarch.getAntiStarchSpec());
        if (null != existList) {
            for (TAntiStarch item : existList) {
                if (!item.getId().equals(tAntiStarch.getId())
                ) {
                    return ResultEnum.AntiStarchSpecs.getState();
                }
            }
        }
        int flag = tAntiStarchMapper.update(tAntiStarch);
        return flag;
    }
    /**
     * 启用禁用
     * @param tAntiStarch
     * @return
     */
    @Override
    public int updateDisabled(TAntiStarch tAntiStarch) {
        int flag = tAntiStarchMapper.updateDisabled(tAntiStarch);
        return flag;
    }
    /**
     * 逻辑删除
     * @param tAntiStarch
     * @return
     */
    @Override
    public int updateDel(TAntiStarch tAntiStarch) {
        int flag = tAntiStarchMapper.updateDel(tAntiStarch);
        return flag;
    }

    /**
     * 查询主列表信息
     * @param antiStarchSpec
     * @param disabled
     * @param pageNum
     * @param pageSize
     * @return
     */
    @Override
    public PageInfo findList(String antiStarchSpec, Boolean disabled, Integer pageNum, Integer pageSize) {
        if (null == pageNum) {
            pageNum = 1;
        }
        if (null == pageSize) {
            pageSize = 30;
        }
        PageUtil.pageHelper(pageNum, pageSize);
        List<TAntiStarch> tChipList = tAntiStarchMapper.findList(antiStarchSpec,disabled);
        PageInfo pageInfo = new PageInfo(tChipList);
        return pageInfo;
    }
}
