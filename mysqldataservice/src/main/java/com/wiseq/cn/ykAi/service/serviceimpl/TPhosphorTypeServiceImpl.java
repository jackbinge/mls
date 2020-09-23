package com.wiseq.cn.ykAi.service.serviceimpl;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.ykAi.dao.TPhosphorTypeDao;
import com.wiseq.cn.ykAi.service.TPhosphorTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2020/4/11     jiangbailing      原始版本
 * 文件说明:
 */
@Service
public class TPhosphorTypeServiceImpl implements TPhosphorTypeService {
    @Autowired
    private TPhosphorTypeDao tPhosphorTypeDao;

    @Override
    public Result add(String name){
        String[] strings = name.split(",");
       /* for(String iteamName: strings){
           *//* int num = this.tPhosphorTypeDao.findExit(name);
            if(num == 0){
                return ResultUtils.setResult(1,"类型名重复",iteamName);
            }*//*
            this.tPhosphorTypeDao.add(name);
        }*/
        List<String> stringList=Arrays.asList(strings);
        this.tPhosphorTypeDao.batchAdd(stringList);
        return ResultUtils.success();
    }

    @Override
    public Result delete(String id){
        //List<Integer> integerList = Arrays.stream(strings).map(item -> Integer.parseInt(item)).collect(Collectors.toList());
        this.tPhosphorTypeDao.batchDelete(id);
        return ResultUtils.success();
    }

    @Override
    public List<Map<String,Object>> select(){
        return this.tPhosphorTypeDao.select();
    }

    @Override
    public List<Map<String, Object>> getSomeTypePosphor(String phosphorTypes) {
        return this.tPhosphorTypeDao.getSomeTypePosphor(phosphorTypes);
    }

}
