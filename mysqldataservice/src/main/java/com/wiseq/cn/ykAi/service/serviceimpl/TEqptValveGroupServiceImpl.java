package com.wiseq.cn.ykAi.service.serviceimpl;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.exception.QuException;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.*;
import com.wiseq.cn.utils.PageUtil;
import com.wiseq.cn.ykAi.dao.TEqptMapper;
import com.wiseq.cn.ykAi.dao.TEqptValveMapper;
import com.wiseq.cn.ykAi.service.TEqptValveGroupService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/5     lipeng      原始版本
 * 文件说明:点胶页面
 */
@Service
@Transactional
public class TEqptValveGroupServiceImpl implements TEqptValveGroupService {
    @Autowired
    TEqptMapper tEqptMapper;
    @Autowired
    TEqptValveMapper tEqptValveMapper;

    /**
     * 点胶设备信息新增
     */
    @Override
    @Transactional
    public Result insert(TEqptValveGroup tEqptValveGroup) {
        //新增设备
        TEqpt tEqpt = tEqptValveGroup.getTEqpt();

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
        tEqptMapper.insertSelective(tEqpt);
        //新增阀体信息
        List<TEqptValve> tEqptValveList = tEqptValveGroup.getTEqptValveList();
        if (null != tEqptValveList && tEqptValveList.size() > 0) {
            for (TEqptValve tEqptValve : tEqptValveList) {
          //阀体名称重复性校验
                List<TEqptValve> tEqptValves = tEqptValveMapper.findTEqptValveExist(tEqptValve.getName(),tEqptValve.getEqptId());
                if(null != tEqptValves && tEqptValves.size() > 0){
                    throw new QuException(-1,"当前设备中该阀体名称已存在，请勿重复创建");
                }
                //新增阀体信息
                tEqptValve.setEqptId(tEqpt.getId());
                tEqptValveMapper.insertSelective(tEqptValve);
            }
        }
        return ResultUtils.success();
    }
    /**
     * 点胶设备信息启用禁用
     */
    @Override
    public int updateDisabled(Long id, Boolean disable) {
        this.tEqptMapper.updateToDisable(id,disable);
        return 1;
    }
    /**
     * 点胶设备信息逻辑删除
     */
    @Override
    public int updateDel(Long id) {
            int flag = tEqptMapper.updateDel(id);
            return flag;
        }


    /**
     * 修改点胶设备
      * @param tEqpt
     */
    @Override
    @Transactional
    public Result updateEqpt(TEqpt tEqpt){

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
        this.tEqptMapper.updateByPrimaryKeySelective(tEqpt);
        List<TEqptValve> tEqptValveList = tEqpt.getTEqptValveList();



        //新增
        //List<TEqptValve> addList = new ArrayList<>();
        //编辑和删除的
        //List<TEqptValve> editList = new ArrayList<>();

        for (TEqptValve t:
            tEqptValveList) {

            t.setEqptId(tEqpt.getId());

            if(null==t.getId()){
                this.tEqptValveMapper.insertSelective(t);
            }else {
                this.tEqptValveMapper.updateByPrimaryKeySelective(t);
            }
        }
        return ResultUtils.success();
    }




    /**
     * 点胶设备信息主列表查询
     */
    @Override
    public PageInfo findList(Long groupId, String positon, String assetsCode, Boolean disabled, Integer pageNum, Integer pageSize) {
        if (null == pageNum) {
            pageNum = 1;
        }
        if (null == pageSize) {
            pageSize = 30;
        }
        PageUtil.pageHelper(pageNum, pageSize);

        List<TEqpt> tEqptList = tEqptMapper.findList(groupId,positon,assetsCode, disabled);
        PageInfo pageInfo = new PageInfo(tEqptList);
        return pageInfo;
    }

    /**
     * 查询阀体列表信息
     * @param eqptId
     * @return
     */
    @Override
    public List<TEqptValve> findTeqptValveList(Long eqptId) {
        List<TEqptValve> tEqptList = tEqptValveMapper.findTeqptValveList(eqptId);
        return tEqptList;
    }
}


