package com.wiseq.cn.ykAi.service.serviceimpl;

import com.wiseq.cn.entity.ykAi.TEqptValve;
import com.wiseq.cn.ykAi.dao.TEqptValveMapper;
import com.wiseq.cn.ykAi.service.TEqptValveService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/5     lipeng      原始版本
 * 文件说明:  
 */
@Service
public class TEqptValveServiceImpl implements TEqptValveService {

    @Autowired
    TEqptValveMapper tEqptValveMapper;

    @Override
    public int deleteByPrimaryKey(Long id) {
        return tEqptValveMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int insertSelective(TEqptValve record) {
        return tEqptValveMapper.insertSelective(record);
    }

    @Override
    public TEqptValve selectByPrimaryKey(Long id) {
        return tEqptValveMapper.selectByPrimaryKey(id);
    }

    @Override
    public int updateByPrimaryKeySelective(TEqptValve record) {
        return 0;
    }

    @Override
    public int updateByPrimaryKey(TEqptValve record) {
        return tEqptValveMapper.updateByPrimaryKey(record);
    }

}
