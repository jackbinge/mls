package com.wiseq.cn.ykAi.service.serviceimpl;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TColorRegion;
import com.wiseq.cn.entity.ykAi.TColorRegionMix;
import com.wiseq.cn.utils.PageUtil;
import com.wiseq.cn.ykAi.dao.TColorRegionDtlMapper;
import com.wiseq.cn.ykAi.dao.TColorRegionMapper;
import com.wiseq.cn.ykAi.service.TColorRegionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/6     lipeng      原始版本
 * 文件说明:  色区
 */
@Service
public class TColorRegionServiceImpl implements TColorRegionService {

    @Autowired
    TColorRegionMapper tColorRegionMapper;
    @Autowired
    TColorRegionDtlMapper tColorRegionDtlMapper;

    /**
     * 查询色区主列表
     * @param spec
     * @param processType
     * @param pageNum
     * @param pageSize
     * @return
     */
    @Override
    public PageInfo findList(String spec, Byte processType, Integer pageNum, Integer pageSize) {
        if (null == pageNum) {
            pageNum = 1;
        }
        if (null == pageSize) {
            pageSize = 30;
        }
        PageUtil.pageHelper(pageNum, pageSize);
        List<TColorRegionMix> tColorRegionMixList = tColorRegionMapper.findList(spec, processType);
        PageInfo pageInfo = new PageInfo(tColorRegionMixList);
        return pageInfo;
    }

    @Override
    @Transactional
    public Result updateDelbunch(List<TColorRegion> tColorRegionList) {
        for(TColorRegion tColorRegion:tColorRegionList){
            tColorRegionMapper.update(tColorRegion);
        }
        return ResultUtils.success();
    }

}
