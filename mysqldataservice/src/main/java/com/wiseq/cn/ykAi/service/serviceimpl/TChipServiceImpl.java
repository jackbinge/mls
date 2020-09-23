package com.wiseq.cn.ykAi.service.serviceimpl;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TChipWlRank;
import com.wiseq.cn.utils.PageUtil;
import com.wiseq.cn.ykAi.dao.TChipDao;
import com.wiseq.cn.ykAi.dao.TChipWlRankDao;
import com.wiseq.cn.ykAi.service.TChipService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/9/10       lipeng      原始版本
 * 文件说明:原材料库-芯片
 */
@Service
public class TChipServiceImpl implements TChipService {
    @Autowired
    TChipDao tChipMapper;
    @Autowired
    TChipWlRankDao tChipWlRankDao;

    /**
     * 原材料库-芯片-新增芯片信息
     *
     * @param jsonObject {"tChip":{"key1":value1,"key2":value2},
     *                   "tChipWIrankList":[{"name":a,"wlMax":11,"wlMin":0},{"name":b,"wlMax":12,"wlMin":1}] }
     * @return
     */
    @Override
    public int insert(JSONObject jsonObject) {

        TChip tChip = JSONObject.parseObject(jsonObject.getString("tchip").toString(), TChip.class);

        if (null == tChip.getChipSpec()) {
            return ResultEnum.ChipSpec.getState();
        }
        if (null == tChip.getTestCondition()) {
            return ResultEnum.testCondition.getState();
        }
        if (null == tChip.getVfMax()) {
            return ResultEnum.Vf.getState();
        }
        if (null == tChip.getVfMin()) {
            return ResultEnum.Vf.getState();
        }
        if (null == tChip.getIvMax()) {
            return ResultEnum.Iv.getState();
        }
        if (null == tChip.getIvMin()) {
            return ResultEnum.Iv.getState();
        }
        if (null == tChip.getLumenMax()) {
            return ResultEnum.Lumen.getState();
        }
        if (null == tChip.getLumenMin()) {
            return ResultEnum.Lumen.getState();
        }
        //对芯片规格做重复性校验
        List<TChip> existList = tChipMapper.findExistList(tChip.getChipSpec(),tChip.getId());
        if (null != existList) {
            return ResultEnum.tChip.getState();
        }
        //插入芯片数据
        tChipMapper.insert(tChip);
        //解析波段
        List<TChipWlRank> tChipWlRankList = jsonObject.getJSONArray("tChipWIrankList").toJavaList(TChipWlRank.class);
        if (null != tChipWlRankList && tChipWlRankList.size() > 0) {
            for (TChipWlRank tChipWlRank : tChipWlRankList) {
                //对波段名称进行你重复性验证
                List<TChipWlRank> tChipWlRankExistList = tChipWlRankDao.tChipWlRankExistList(tChipWlRank.getName());
                if (null != tChipWlRankExistList) {
                    return ResultEnum.tChipWlRank.getState();
                }
                tChipWlRank.setChipId(tChip.getId());
                //插入芯片波段数据
                tChipWlRankDao.insert(tChipWlRank);
            }
        }
        return 1;
    }

    /**
     * 原材料库-芯片-修改芯片信息
     *
     * @param jsonObject
     * @return
     */
    @Override
    public int update(JSONObject jsonObject) {

        TChip tChip = JSONObject.parseObject(jsonObject.getString("tchip").toString(), TChip.class);

        if (null == tChip.getChipSpec()) {
            return ResultEnum.ChipSpec.getState();
        }
        if (null == tChip.getTestCondition()) {
            return ResultEnum.testCondition.getState();
        }
        if (null == tChip.getVfMax()) {
            return ResultEnum.Vf.getState();
        }
        if (null == tChip.getVfMin()) {
            return ResultEnum.Vf.getState();
        }
        if (null == tChip.getIvMax()) {
            return ResultEnum.Iv.getState();
        }
        if (null == tChip.getIvMin()) {
            return ResultEnum.Iv.getState();
        }
        if (null == tChip.getLumenMax()) {
            return ResultEnum.Lumen.getState();
        }
        if (null == tChip.getLumenMin()) {
            return ResultEnum.Lumen.getState();
        }
        //对芯片规格做重复性校验
        List<TChip> existList = tChipMapper.findExistList(tChip.getChipSpec(),tChip.getId());
        if (null != existList) {
            return ResultEnum.tChip.getState();
        }
        //插入芯片数据
        tChipMapper.update(tChip);
        //解析波段
        List<TChipWlRank> tChipWlRankList = jsonObject.getJSONArray("tChipWIrankList").toJavaList(TChipWlRank.class);
        if (null != tChipWlRankList && tChipWlRankList.size() > 0) {
            for (TChipWlRank tChipWlRank : tChipWlRankList) {
                //对波段名称进行重复性验证
                List<TChipWlRank> tChipWlRankExistList = tChipWlRankDao.tChipWlRankExistList(tChipWlRank.getName());
                if (null != tChipWlRankExistList) {
                    return ResultEnum.tChipWlRank.getState();
                }
                tChipWlRank.setChipId(tChip.getId());
                //修改芯片波段数据
                tChipWlRankDao.update(tChipWlRank);
            }
        }
        return 1;
    }

        //查询芯片信息主列表
        @Override
        public PageInfo findList (String chipSpec, Boolean disabled, Integer pageNum, Integer pageSize){
            if (null == pageNum) {
                pageNum = 1;
            }
            if (null == pageSize) {
                pageSize = 30;
            }
            PageUtil.pageHelper(pageNum, pageSize);
            List<TChip> tChipList = tChipMapper.findList(chipSpec, disabled);
            PageInfo pageInfo = new PageInfo(tChipList);
            return pageInfo;
        }

        /**
         * 原材料库-芯片-启用禁用
         *
         * @param tChip
         * @return
         */
        @Override
        public int updateDisabled (TChip tChip){
            int flag = tChipMapper.updateDisabled(tChip);
            return flag;
        }

        /**
         * 原材料库-芯片-逻辑删除
         *
         * @param tChip
         * @return
         */
        @Override
        public int updateDel (TChip tChip){
            int flag = tChipMapper.updateDel(tChip);
            return flag;
        }

    }

