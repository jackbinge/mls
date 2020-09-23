package com.wiseq.cn.ykAi.service.serviceimpl;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.RuleKindEnum;
import com.wiseq.cn.commons.exception.QuException;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.commons.utils.RoundTool;
import com.wiseq.cn.entity.ykAi.TBeforeTestRule;
import com.wiseq.cn.entity.ykAi.TOutputRequireBeforeTestRule;
import com.wiseq.cn.ykAi.dao.TBeforeTestRuleDao;
import com.wiseq.cn.ykAi.service.TBeforeTestRuleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
public class TBeforeTestRuleServiceImpl implements TBeforeTestRuleService {
    @Autowired
    private TBeforeTestRuleDao tBeforeTestRuleDao;




    @Override
    public Result findDtlByOutputRequireId(Long outputRequireId){



        return ResultUtils.success(this.tBeforeTestRuleDao.findDtlByOutputRequireId(outputRequireId));
    }


    @Override
    @Transactional
    public Result edit(List<TOutputRequireBeforeTestRule> tOutputRequireBeforeTestRules) throws QuException{
        //用list是因为会存在双层结构的数据
        for (TOutputRequireBeforeTestRule tOutputRequireBeforeTestRule:
        tOutputRequireBeforeTestRules) {
            //获取前台传过来的前测数据
            TBeforeTestRule tBeforeTestRule = tOutputRequireBeforeTestRule.getTBeforeTestRule();
            //判定是否有前测数据
            if(tBeforeTestRule==null){
                throw new QuException(1,"没有前测数据无法修改");
            }
            Long beforeTestRuleId=tOutputRequireBeforeTestRule.getTBeforeTestRule().getId();
            Byte ruleKind = tBeforeTestRule.getRuleKind();
            if(ruleKind.equals(RuleKindEnum.Ellipse.getState())){
                tBeforeTestRule.setCpX(tBeforeTestRule.getX());
                tBeforeTestRule.setCpY(tBeforeTestRule.getY());
            }else if(ruleKind.equals(RuleKindEnum.Quadrilateral.getState())){
                Double x1 = tBeforeTestRule.getX1();
                Double x2 = tBeforeTestRule.getX2();
                Double x3 = tBeforeTestRule.getX3();
                Double x4 = tBeforeTestRule.getX4();
                Double y1 = tBeforeTestRule.getY1();
                Double y2 = tBeforeTestRule.getY2();
                Double y3 = tBeforeTestRule.getY3();
                Double y4 = tBeforeTestRule.getY4();
                Double cpX = RoundTool.round(((x1+x2+x3+x4)/4.0D),5, BigDecimal.ROUND_HALF_UP);
                Double cpY = RoundTool.round((y1+y2+y3+y4)/4.0D,5,BigDecimal.ROUND_HALF_UP);
                tBeforeTestRule.setCpX(cpX);
                tBeforeTestRule.setCpY(cpY);

            }else if(ruleKind.equals(RuleKindEnum.Point.getState())){
                if(null == tBeforeTestRule.getCpX()||(null == tBeforeTestRule.getCpY())){
                    throw new QuException(1,"没有中心点数据无法修改");
                }
            }else if(ruleKind.equals(RuleKindEnum.OuputRatio.getState())){
                if(null == tBeforeTestRule.getCpX()||(null == tBeforeTestRule.getCpY())){
                    throw new QuException(1,"没有中心点数据无法修改");
                }
            }
            //前测规则数据ID针对编辑
           /* if(beforeTestRuleId!=null){
                //删除中间表
                this.tBeforeTestRuleDao.deleteTOutputRequireBeforeTestRuleById(beforeTestRuleId);
            }*/

            this.tBeforeTestRuleDao.deleteTOutputRequireByOutputRequireId
                    (tOutputRequireBeforeTestRule.getOutputRequireId());


            //插入前测规则数据
            this.tBeforeTestRuleDao.insertSelective(tBeforeTestRule);
            //获取新插入的数据的前测规则ID
            tOutputRequireBeforeTestRule.setBeforeTestRuleId(tBeforeTestRule.getId());

            //新增中间表
            this.tBeforeTestRuleDao.insertOutRequireToBeforeTestTable(tOutputRequireBeforeTestRule);
        }

        return ResultUtils.success();
    }
}
