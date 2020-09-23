package com.wiseq.cn.ykAi.service.serviceimpl;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TIdAndNum;
import com.wiseq.cn.entity.ykAi.TTypeMachineDefaultSetFrontToBack;
import com.wiseq.cn.ykAi.dao.TTypeMachineDefaultSetDao;
import com.wiseq.cn.ykAi.service.TTypeMachineDefaultSetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/13     jiangbailing      原始版本
 * 文件说明:
 */
@Service
public class TTypeMachineDefaultSetServiceImpl implements TTypeMachineDefaultSetService {
    @Autowired
    private TTypeMachineDefaultSetDao tTypeMachineDefaultSetDao;

    @Override
    public Result set(TTypeMachineDefaultSetFrontToBack data){
        Integer typeMachineId = data.getTypeMachineId();
        List<Integer> defalultchip = data.getDefalultchip();
        tTypeMachineDefaultSetDao.deleteDefaultChip(typeMachineId);
        tTypeMachineDefaultSetDao.deleteTypeMachineDefaultOtherMaterial(typeMachineId);
        tTypeMachineDefaultSetDao.insertDefaultChip(defalultchip,typeMachineId);
        tTypeMachineDefaultSetDao.insertTypeMachineDefaultOtherMaterial(data);
        return ResultUtils.success();
    }

    @Override
    public Map<String,Object> select(Integer typeMachineId){
        Map<String,Object> data = new HashMap<>();
        List<Map<String,Object>> limitPhosphorTypes = tTypeMachineDefaultSetDao.getLimitPhosphorType(typeMachineId);
        List<Map<String,Object>> defaultChip = tTypeMachineDefaultSetDao.getDefaultChip(typeMachineId);
        Map<String,Object> otherDefault = tTypeMachineDefaultSetDao.getOtherDefault(typeMachineId);
        data.put("limitPhosphorType",limitPhosphorTypes);
        data.put("defaultChip",defaultChip);
        data.put("otherDefault",otherDefault);
        return data;
    }

}
