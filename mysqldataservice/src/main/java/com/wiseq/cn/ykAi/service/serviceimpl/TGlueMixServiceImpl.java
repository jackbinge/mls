package com.wiseq.cn.ykAi.service.serviceimpl;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.exception.QuException;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TABGlue;
import com.wiseq.cn.entity.ykAi.TGlue;
import com.wiseq.cn.entity.ykAi.TGlueDtl;
import com.wiseq.cn.entity.ykAi.TGlueMix;
import com.wiseq.cn.utils.PageUtil;
import com.wiseq.cn.ykAi.dao.TGlueDtlDao;
import com.wiseq.cn.ykAi.dao.TGlueDao;
import com.wiseq.cn.ykAi.service.TGlueMixService;
import net.bytebuddy.implementation.bytecode.Throw;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/31       lipeng      原始版本
 * 文件说明:  原材料库-胶水比例
 */
@Service
@Transactional
public class TGlueMixServiceImpl implements TGlueMixService {

    @Autowired
    TGlueDao tGlueMapper;

    @Autowired
    TGlueDtlDao tGlueDtlMapper;



    /**
     * 新增胶水比例信息
     *
     * @return
     */

    @Override
    @Transactional
    public Result insert(List<TGlueMix> tGlueMixList) throws QuException{

        if (tGlueMixList.size() > 0) {
            TGlue  tGlue = tGlueMixList.get(0).getTGlue();
            tGlue.setRatioB(tGlueMixList.get(1).getTGlue().getRatioB());
            //新增胶水比例数据

            tGlueMapper.insert(tGlue);

            for (TGlueMix tGlueMix : tGlueMixList) {
                if(null == tGlueMix.getTGlueDtl()){
                    throw new QuException(1,"数据不完整");
                }
                //新增胶水详情
                if(null != tGlueMix.getTGlueDtl()){
                    List<TGlueDtl> tGlueDtlList =  tGlueDtlMapper.findExist(tGlueMix.getTGlueDtl().getGlueSpec(),tGlueMix.getTGlueDtl().getId());
                    if(tGlueDtlList.size()>0){
                        throw  new QuException(-1,"该胶水规格已经存在，请勿重复添加");
                    }
                    tGlueMix.getTGlueDtl().setGlueId(tGlue.getId());
                    tGlueDtlMapper.insertSelective(tGlueMix.getTGlueDtl());
                }
            }
        }
        return ResultUtils.success();
    }

    /**
     * 修改胶水数据
     *
     * @param tGlueMixList
     * @return
     */
    @Override
    @Transactional
    public Result update(List<TGlueMix> tGlueMixList)throws QuException {
        //修改胶水比例数据

        if (tGlueMixList.size() > 0 ) {
            for (TGlueMix tGlueMix : tGlueMixList) {
                if(tGlueMix.getId() == null){
                    return  ResultUtils.error(1,"数据不完整无法修改");
                }
                //修改胶水比例数据
                if (null != tGlueMix.getTGlue()) {
                    tGlueMapper.update(tGlueMix.getTGlue());
                }
                //修改胶水详情
                if(null != tGlueMix.getTGlueDtl()){
                    List<TGlueDtl> tGlueDtlList =  tGlueDtlMapper.findExist(tGlueMix.getTGlueDtl().getGlueSpec(),tGlueMix.getTGlueDtl().getId());
                    if(tGlueDtlList.size()>0){
                        throw  new QuException(-1,"该胶水规格已经存在，请勿重复添加");
                    }
                    //修改胶水详情数据
                    tGlueDtlMapper.update(tGlueMix.getTGlueDtl());
                }
            }
        }
        return ResultUtils.success();
    }


}
