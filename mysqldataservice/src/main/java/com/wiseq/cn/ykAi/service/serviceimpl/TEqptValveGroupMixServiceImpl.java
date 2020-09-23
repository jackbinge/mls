package com.wiseq.cn.ykAi.service.serviceimpl;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.exception.QuException;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TEqpt;
import com.wiseq.cn.entity.ykAi.TEqptValve;
import com.wiseq.cn.entity.ykAi.TEqptValveGroup;
import com.wiseq.cn.entity.ykAi.TEqptValveGroupMix;
import com.wiseq.cn.ykAi.dao.TEqptMapper;
import com.wiseq.cn.ykAi.dao.TEqptValveMapper;
import com.wiseq.cn.ykAi.service.TEqptValveGroupMixService;
import com.wiseq.cn.ykAi.service.TEqptValveGroupService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/5     lipeng      原始版本
 * 文件说明:文件说明:点胶页面编辑
 */
@Service
@Transactional
public class TEqptValveGroupMixServiceImpl implements TEqptValveGroupMixService {
    @Autowired
    TEqptMapper tEqptMapper;
    @Autowired
    TEqptValveMapper tEqptValveMapper;

    /**
     * 点胶设备信息新增
     */
    @Override
    public Result update(TEqptValveGroupMix tEqptValveGroupMix) {
        TEqpt tEqpt = tEqptValveGroupMix.getEqpt();
        if (null != tEqpt) {
            //资产编码验证如果有则获取错误信息
            String errorMessage = tEqptMapper.findTEqptAssetsCodeExist(tEqpt.getAssetsCode(),tEqpt.getId());
            //位置编码验证
            List<TEqpt> list = tEqptMapper.findTEqptExistPositon(tEqpt.getPositon(),tEqpt.getGroupId(),tEqpt.getId());

            if(errorMessage!=null){
                return ResultUtils.error(1,errorMessage);
            }
            if(list.size()>0){
                return ResultUtils.error(1,"位置编码重复");
            }
            //修改机台信息
            tEqptMapper.updateByPrimaryKeySelective(tEqpt);
        }else{
            return ResultUtils.error(1,"数据不完整无法修改");
        }


        List<TEqptValve> tEqptValveInsert = tEqptValveGroupMix.getTEqptValveInsert();
        //是新增的时候
        if (tEqptValveInsert != null && tEqptValveInsert.size() > 0) {
            for (TEqptValve tEqptValve : tEqptValveInsert) {
                List<TEqptValve> tEqptValveList = tEqptValveMapper.findTEqptValveExist(tEqptValve.getName(),tEqpt.getId());
                if(tEqptValveList.size()>0){
                    throw new QuException(-1,"该设备的阀体已存在，请勿重复创建");
                }
                tEqptValve.setEqptId(tEqpt.getId());
                tEqptValveMapper.insertSelective(tEqptValve);
            }
        }
        // 是修改的时候
        if (tEqptValveInsert != null && tEqptValveInsert.size() > 0) {
            for (TEqptValve tEqptValve : tEqptValveInsert) {
                List<TEqptValve> tEqptValveList = tEqptValveMapper.findTEqptValveExist(tEqptValve.getName(),tEqpt.getId());
                if(tEqptValveList.size()>0){
                    throw new QuException(-1,"该设备的阀体已存在，请勿重复创建");
                }
//                tEqptValve.setEqptId(tEqpt.getId());
                tEqptValveMapper.updateByPrimaryKeySelectives(tEqptValve);
            }
        }
        //删除的时候
        if (tEqptValveInsert != null && tEqptValveInsert.size() > 0) {
            for (TEqptValve tEqptValve : tEqptValveInsert) {
//                tEqptValve.setEqptId(tEqpt.getId());
                tEqptValveMapper.deleteSelectives(tEqptValve);
            }
        }
        return ResultUtils.success();
    }


}
