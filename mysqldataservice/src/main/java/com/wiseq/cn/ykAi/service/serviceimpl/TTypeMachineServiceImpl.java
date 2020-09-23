package com.wiseq.cn.ykAi.service.serviceimpl;
import	java.beans.Transient;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TTypeMachine;
import com.wiseq.cn.entity.ykAi.TTypeMachineGuleHigh;
import com.wiseq.cn.ykAi.dao.TTypeMachineDao;
import com.wiseq.cn.ykAi.dao.TTypeMachineGuleHighDao;
import com.wiseq.cn.ykAi.service.TTypeMachineService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/6      jiangbailing      原始版本
 * 文件说明:基础库-机种库
 */
@Service
public class TTypeMachineServiceImpl implements TTypeMachineService {
    @Autowired
    private TTypeMachineDao tTypeMachineDao;
    @Autowired
    private TTypeMachineGuleHighDao tTypeMachineGuleHighDao;

    /**
     * 获取机种信息
     * @return
     */
    @Override
    public PageInfo<TTypeMachine> selectAll(String spec, Byte processType, Boolean disabled, Integer pageNum, Integer pageSize,Integer crystalNumber){
        PageHelper.startPage(pageNum,pageSize);

        PageInfo pageInfo = new PageInfo(this.tTypeMachineDao.findList(spec, processType, disabled,crystalNumber));


        return pageInfo;
    }


    /**
     * 通过主键获取机种信息
     * @param id
     * @return
     */
    public Result selectByPrimaryKey(Long id){
        this.tTypeMachineDao.selectByPrimaryKey(id);
        return ResultUtils.success();
    }

    /**
     * 新增
     * @param record
     * @return
     */
    @Override
    @Transactional
    public Result  insert(TTypeMachine record){
        List<TTypeMachine> list= this.tTypeMachineDao.findTTypeMachineBySpec(record.getSpec());
        if(list.size()>0){
            return ResultUtils.error(1,"机种规格重复");
        }
        this.tTypeMachineDao.insertSelective(record);
        List<TTypeMachineGuleHigh> tTypeMachineGuleHighList =record.getTTypeMachineGuleHigh();
        for (TTypeMachineGuleHigh th:
        tTypeMachineGuleHighList) {
            th.setTypeMachineId(record.getId());
            this.tTypeMachineGuleHighDao.insertSelective(th);
        }

        return ResultUtils.success();
    }


    /**
     * 删除按钮
     * @param id
     * @return
     */
    @Override
    public Result deleteByPrimaryKey(Long id){
        this.tTypeMachineDao.deleteByPrimaryKey(id);
        return ResultUtils.success();
    }


    /**
     * 修改传要修改的机种ID和要修改的字段
     * @param record
     * @return
     */
    @Override
    public Result updateByPrimaryKeySelective(TTypeMachine record){
        List<TTypeMachineGuleHigh>  tTypeMachineGuleHigh = record.getTTypeMachineGuleHigh();
        this.tTypeMachineDao.updateByPrimaryKeySelective( record);
        tTypeMachineGuleHigh.forEach( o -> {
            this.tTypeMachineDao.updateTypeMachineGlueHigh(record.getId(),o.getGuleHightUsl(),o.getGuleHightLsl());
        });

        return ResultUtils.success();
    }

    /**
     * 禁用启用
     * 修改传要修改的机种ID和是否禁用disabled
     * @param record
     * @return
     */
    @Override
    public Result updateOnAndOff(TTypeMachine record){
        this.tTypeMachineDao.updateOnAndOff( record);
        return ResultUtils.success();
    }

    /**
     * 获取测试规则页面的首页列表
     * @param spec
     * @param processType
     * @param pageNum
     * @param pageSize
     * @return
     */
    @Override
    public Result findTypeMatchineListForTest( String spec,
                                               Byte processType,
                                               Integer pageNum,Integer pageSize,Integer crystalNumber){
        PageHelper.startPage(pageNum,pageSize);
        PageInfo pageInfo = new PageInfo(this.tTypeMachineDao.findTypeMatchineListForTest(spec, processType,crystalNumber));
        return ResultUtils.success(pageInfo);
    }


    /**
     * 获取机种信息通过机种ID
     * @param typeMachineId
     * @return
     */
    @Override
    public Result findTypeMachineById(Long typeMachineId){
       return ResultUtils.success( this.tTypeMachineDao.findTypeMachineById(typeMachineId));
    }
}
