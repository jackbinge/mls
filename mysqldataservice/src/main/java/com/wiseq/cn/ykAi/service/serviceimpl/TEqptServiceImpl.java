package com.wiseq.cn.ykAi.service.serviceimpl;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TEqpt;
import com.wiseq.cn.entity.ykAi.TGroup;
import com.wiseq.cn.ykAi.dao.TEqptMapper;
import com.wiseq.cn.ykAi.service.TEqptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/5     lipeng      原始版本
 * 文件说明:  
 */
@Service
public class TEqptServiceImpl implements TEqptService {
    @Autowired
    TEqptMapper tEqptMapper;

    /**
     * 点胶设备信息新增
     * {"tEqpt":{"key1":value1,"key2":value2},
     * "tGroup":{"key1":value1,"key2":value2},
     *      *                   "tEqptValva":[{"name":a,"wlMax":11,"wlMin":0},{"name":b,"wlMax":12,"wlMin":1}] }
     */
//    @Override
//    public int insert(JSONObject jsonObject) {
//        //新增设备
//        TEqpt tEqpt = JSONObject.parseObject(jsonObject.getString("tEqpt").toString(),TEqpt.class);
//        //设备资产编码+设备位置编码唯一
//        List<TEqpt> tEqptList = tEqptMapper.findTEqptExist(tEqpt.getPositon(),tEqpt.getAssetsCode());
//        if(null!= tEqptList && tEqptList.size()>0){
//            return ResultEnum.tEqptList.getState();
//        }
//        tEqptMapper.insertSelective(tEqpt);
//        //新增地域信息(待定)
//        TGroup tGroup = JSONObject.parseObject(jsonObject.getString("tGroup").toString(),TGroup.class);
//
//        return 0;
//    }

//    @Override
//    public int update(JSONObject jsonObject) {
//        return 0;
//    }

    @Override
    public int updateDisabled(TEqpt tEqpt) {
        return 0;
    }

    @Override
    public int updateDel(TEqpt tEqpt) {
        return 0;
    }

    @Override
    public PageInfo findList(String chipSpec, Boolean disabled, Integer pageNum, Integer pageSize) {
        return null;
    }
}
