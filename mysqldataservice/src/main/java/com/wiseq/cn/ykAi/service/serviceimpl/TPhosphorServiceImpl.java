package com.wiseq.cn.ykAi.service.serviceimpl;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.entity.ykAi.TPhosphor;
import com.wiseq.cn.utils.PageUtil;
import com.wiseq.cn.ykAi.dao.TPhosphorDao;
import com.wiseq.cn.ykAi.service.TPhosphorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:  原材料库-荧光粉
 */
@Service
public class TPhosphorServiceImpl implements TPhosphorService {

    @Autowired
    private TPhosphorDao tPhosphorMapper;

    /**
     * 新增荧光粉
     * @param tPhosphor
     * @return
     */
    @Override
    public int insert(TPhosphor tPhosphor) {
        if (null == tPhosphor.getPhosphorSpec()) {
            return ResultEnum.tPhosphorSpec.getState();
        }
        if (null == tPhosphor.getDensity()) {
            return ResultEnum.Density.getState();
        }
        if (null == tPhosphor.getPeakWavelength()) {
            return ResultEnum.PeakWavelength.getState();
        }
        //对荧光粉规格做重复性校验
        List<TPhosphor> existList = tPhosphorMapper.findExistList(tPhosphor.getPhosphorSpec());
        if (existList.size()>0) {
            return ResultEnum.PhosphorSpec.getState();
        }
        int flag = tPhosphorMapper.insert(tPhosphor);
        return flag;
    }

    /**
     * 修改荧光粉
     * @param tPhosphor
     * @return
     */
    @Override
    public int update(TPhosphor tPhosphor) {
        if (null == tPhosphor.getPhosphorSpec()) {
            return ResultEnum.tPhosphorSpec.getState();
        }
        if (null == tPhosphor.getDensity()) {
            return ResultEnum.Density.getState();
        }
        if (null == tPhosphor.getPeakWavelength()) {
            return ResultEnum.PeakWavelength.getState();
        }
        //对荧光粉规格做重复性校验
        List<TPhosphor> existList = tPhosphorMapper.findExistList(tPhosphor.getPhosphorSpec());
        if (null != existList) {
            for (TPhosphor item : existList) {
                if (!item.getId().equals(tPhosphor.getId())
                ) {
                    return ResultEnum.PhosphorSpec.getState();
                }
            }
        }
        int flag = tPhosphorMapper.update(tPhosphor);
        return flag;
    }

    /**
     * 启用禁用
     * @param tPhosphor
     * @return
     */
    @Override
    public int updateDisabled(TPhosphor tPhosphor) {
        int flag = tPhosphorMapper.updateDisabled(tPhosphor);
        return flag;
    }

    /**
     * 逻辑删除
     * @param tPhosphor
     * @return
     */
    @Override
    public int updateDel(TPhosphor tPhosphor) {
        int flag = tPhosphorMapper.updateDel(tPhosphor);
        return flag;
    }

    /**
     * 查询荧光粉主列表
     * @param phosphorSpec
     * @param disabled
     * @param pageNum
     * @param pageSize
     * @return
     */
    @Override
    public PageInfo findList(String phosphorSpec, Boolean disabled, Integer pageNum, Integer pageSize,String phosphorType,Integer phosphorTypeId) {
        if (null == pageNum) {
            pageNum = 1;
        }
        if (null == pageSize) {
            pageSize = 30;
        }
        PageUtil.pageHelper(pageNum, pageSize);
        List<TPhosphor> tPhosphorList = tPhosphorMapper.findList(phosphorSpec,disabled,phosphorType,phosphorTypeId);
        PageInfo pageInfo = new PageInfo(tPhosphorList);
        return pageInfo;
    }

}
