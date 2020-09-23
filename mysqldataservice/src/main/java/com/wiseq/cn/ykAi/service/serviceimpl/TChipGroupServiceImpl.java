package com.wiseq.cn.ykAi.service.serviceimpl;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.exception.QuException;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TChipGroup;
import com.wiseq.cn.entity.ykAi.TChipWlRank;
import com.wiseq.cn.utils.PageUtil;
import com.wiseq.cn.ykAi.dao.TChipDao;
import com.wiseq.cn.ykAi.dao.TChipWlRankDao;
import com.wiseq.cn.ykAi.service.TChipGroupService;
import com.wiseq.cn.ykAi.service.TChipService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/9/10       lipeng      原始版本
 * 文件说明:原材料库-芯片
 */
@Service
@Transactional
public class TChipGroupServiceImpl implements TChipGroupService {
    @Autowired
    TChipDao tChipMapper;
    @Autowired
    TChipWlRankDao tChipWlRankDao;

    /**
     * 编辑操作
     *
     * @param tChipGroup
     * @return
     */
    @Override
    @Transactional
    public Result update(TChipGroup tChipGroup) {

        TChip tChip = tChipGroup.getTChip();

        //名字重复验证
        List<TChip> tChipList = tChipMapper.findExistList(tChip.getChipSpec(),tChip.getId());
        if (tChipList.size() > 0) {
            return ResultUtils.error(1,"该芯片规格已经存在，请勿重复创建");
        }
        //修改芯片数据
        tChipMapper.update(tChip);
        //增加的时候
        List<TChipWlRank> tChipWlRankInsertList = tChipGroup.getTChipWlRankInsertList();
        if (tChipWlRankInsertList.size() > 0) {
            for (TChipWlRank tChipWlRank : tChipWlRankInsertList) {
                tChipWlRank.setChipId(tChip.getId());
                //芯片波段新增
                tChipWlRankDao.insert(tChipWlRank);
            }
        }

        //修改的时候
        List<TChipWlRank> tChipWlRankUpdateList = tChipGroup.getTChipWlRankUpdateList();


        //芯片波段修改
        if (tChipWlRankUpdateList.size() > 0) {
            for (TChipWlRank tChipWlRank : tChipWlRankUpdateList) {
                tChipWlRank.setChipId(tChip.getId());
                //获取原有的芯片波段数据
                TChipWlRank oldTChipWlRank = tChipWlRankDao.findTChipWlRank(tChipWlRank.getId());
                if(!oldTChipWlRank.equals(tChipWlRank)){
                    //如果不相等先删除
                    this.tChipWlRankDao.updateDelete(tChipWlRank);
                    //再新增
                    this.tChipWlRankDao.insert(tChipWlRank);
                }
            }
        }

        //删除的时候
        List<TChipWlRank> tChipWlRankDelList = tChipGroup.getTChipWlRankDelList();
        if (tChipWlRankDelList.size() > 0) {
            //批量删除
            tChipWlRankDao.batchDelete(tChipWlRankDelList);
        }
        return ResultUtils.success();
    }

    /**
     * 新增操作
     *
     * @param tChipGroup
     * @return
     */
    @Override
    @Transactional
    public Result insert(TChipGroup tChipGroup) {
        TChip tChip = tChipGroup.getTChip();
        if (null != tChip) {
            List<TChip> tChipList = tChipMapper.findExistList(tChip.getChipSpec(),tChip.getId());
            if (tChipList.size() > 0) {
                return ResultUtils.error(1,"该芯片规格已经存在，请勿重复创建");
            }
            tChipMapper.insert(tChip);
        }
        List<TChipWlRank> tChipWlRankList = tChipGroup.getTChipWlRankInsertList();
        if(tChipWlRankList.size()>0){
            for(TChipWlRank tChipWlRank:tChipWlRankList){
              /*List<TChipWlRank> tChipWlRanks = tChipWlRankDao.findtChipWlRankExistList(tChipWlRank.getName());
                if(tChipWlRanks.size()>0){
                    return ResultUtils.error(-1,"该芯片波段名称已经存在，请勿重复创建");
                }*/
                tChipWlRank.setChipId(tChip.getId());
               tChipWlRankDao.insert(tChipWlRank);
            }
        }
        return ResultUtils.success();
    }
}

