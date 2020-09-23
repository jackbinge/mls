package com.wiseq.cn.ykAi.service.serviceimpl;
import java.util.List;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TSpcRule;
import com.wiseq.cn.entity.ykAi.TSpcRuleDtl;
import com.wiseq.cn.entity.ykAi.TSpcRuleMix;
import com.wiseq.cn.ykAi.dao.TOutputRequirementsDao;
import com.wiseq.cn.ykAi.dao.TSpcRuleDao;
import com.wiseq.cn.ykAi.service.TSpcRuleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TSpcRuleServiceImpl implements TSpcRuleService {
    @Autowired
    private TSpcRuleDao tSpcRuleDao;
    @Autowired
    private TOutputRequirementsDao tOutputRequirementsDao;
    private Byte BINQcPoint = 0;
    private Byte XYQcPoint = 1;

    @Override
    public TSpcRuleMix findSpcRuleMix(Long tTypeMachineId){
         TSpcRuleMix tSpcRuleMix = new TSpcRuleMix();
         TSpcRule tSpcRule= this.tSpcRuleDao.selectSpcRuleByTypeMachineId(tTypeMachineId);
         if(tSpcRule!=null){
             List<TSpcRuleDtl> spcRuleDtls = this.tSpcRuleDao.selectSpcRuleDtlByQcRuleId(tSpcRule.getId());
             tSpcRuleMix.setTSpcRuleDtls(spcRuleDtls);
         }
         tSpcRuleMix.setTSpcRule(tSpcRule);
         tSpcRuleMix.setTSpcBaseRules(this.tSpcRuleDao.selectSpcBaseRule());
         return tSpcRuleMix;
     }



     @Transactional
     @Override
     public Result edit(TSpcRuleMix tSpcRuleMix){
        List<TSpcRuleDtl> spcRuleDtls=tSpcRuleMix.getTSpcRuleDtls();
        TSpcRule tSpcRule= tSpcRuleMix.getTSpcRule();
         //出货比例
         List list1=tOutputRequirementsDao.selectByTypeMachineId(tSpcRule.getTypeMachineId(),(byte)1,null,null);
         //中心点类型
         List list2=tOutputRequirementsDao.selectByTypeMachineId(tSpcRule.getTypeMachineId(),(byte)2,null,null);
         Byte qcPoint = tSpcRule.getQcPoint();

         if((list1.size()>0 || list2.size()>0)&& qcPoint == BINQcPoint){
             return ResultUtils.error(1,"有中心点类型的出货要求，无法创建落BIN率型的SPC规则");
         }
         //旧的spc规则
         TSpcRule oldeSpcRule= this.tSpcRuleDao.selectSpcRuleByTypeMachineId(tSpcRule.getTypeMachineId());
         //如果不存在新增
         if(oldeSpcRule==null){
             this.tSpcRuleDao.insertSpcRuleSelective(tSpcRule);
         }else{
             //存在编辑
             tSpcRule.setId(oldeSpcRule.getId());
             this.tSpcRuleDao.updateTSpcRuleSelective(tSpcRule);
         }

        //删除spc规则详情
        this.tSpcRuleDao.deleteTSpcRuleDtlByQcRuleId(tSpcRule.getId());

        for (TSpcRuleDtl t:
        spcRuleDtls) {
          t.setQcRuleId(tSpcRule.getId());
        }

        this.tSpcRuleDao.batchInsertTSpcRuleDtl(spcRuleDtls);
        return ResultUtils.success();
    }
}
