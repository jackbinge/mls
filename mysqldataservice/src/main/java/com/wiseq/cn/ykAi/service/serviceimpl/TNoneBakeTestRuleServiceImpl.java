package com.wiseq.cn.ykAi.service.serviceimpl;
import	java.awt.Desktop.Action;
import java.math.BigDecimal;
import java.util.List;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.RuleKindEnum;
import com.wiseq.cn.commons.exception.QuException;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.commons.utils.RoundTool;
import com.wiseq.cn.entity.ykAi.TNoneBakeTestRule;
import com.wiseq.cn.entity.ykAi.TOutputRequireNbakeRule;
import com.wiseq.cn.ykAi.dao.TNoneBakeTestRuleDao;
import com.wiseq.cn.ykAi.service.TNoneBakeTestRuleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TNoneBakeTestRuleServiceImpl implements TNoneBakeTestRuleService {
    @Autowired
    private TNoneBakeTestRuleDao tNoneBakeTestRuleDao;

    /**
     * 获取非正常烤的类型和详情
     * @param outputRequireId
     * @return
     */
    @Override
    public Result findTOutputRequireNbakeRuleByOutputRequireId(Long outputRequireId){
        return ResultUtils.success(this.tNoneBakeTestRuleDao.findTOutputRequireNbakeRuleByOutputRequireId(outputRequireId));
    }


    /**
     * 非正常烤编辑
     * @param tOutputRequireNbakeRules
     * @return
     */
    @Override
    @Transactional
    public Result edit(List<TOutputRequireNbakeRule> tOutputRequireNbakeRules)throws QuException{

        for (TOutputRequireNbakeRule tOutputRequireNbakeRule:
            tOutputRequireNbakeRules) {
            TNoneBakeTestRule tNoneBakeTestRule = tOutputRequireNbakeRule.getTNoneBakeTestRule();

            if(null == tNoneBakeTestRule){
                throw new QuException(1,"没有非正常烤的数据更行数据");
            }
            //非正常烤的ID针对编辑的情况
            Long noneBakeRuleId = tNoneBakeTestRule.getId();
            Byte ruleKind = tNoneBakeTestRule.getRuleKind();
            if(ruleKind.equals(RuleKindEnum.Ellipse.getState())){
                tNoneBakeTestRule.setCpX(tNoneBakeTestRule.getX());
                tNoneBakeTestRule.setCpY(tNoneBakeTestRule.getY());
            }else if(ruleKind.equals(RuleKindEnum.Quadrilateral.getState())){
                Double x1 = tNoneBakeTestRule.getX1();
                Double x2 = tNoneBakeTestRule.getX2();
                Double x3 = tNoneBakeTestRule.getX3();
                Double x4 = tNoneBakeTestRule.getX4();
                Double y1 = tNoneBakeTestRule.getY1();
                Double y2 = tNoneBakeTestRule.getY2();
                Double y3 = tNoneBakeTestRule.getY3();
                Double y4 = tNoneBakeTestRule.getY4();
                Double cpX = RoundTool.round(((x1+x2+x3+x4)/4.0D),5, BigDecimal.ROUND_HALF_UP);
                Double cpY = RoundTool.round((y1+y2+y3+y4)/4.0D,5,BigDecimal.ROUND_HALF_UP);
                tNoneBakeTestRule.setCpX(cpX);
                tNoneBakeTestRule.setCpY(cpY);

            }else if(ruleKind.equals(RuleKindEnum.Point.getState())){
                if(null == tNoneBakeTestRule.getCpX()||(null == tNoneBakeTestRule.getCpY())){
                    throw new QuException(1,"没有中心点数据无法修改");
                }
            }else if(ruleKind.equals(RuleKindEnum.OuputRatio.getState())){
                if(null == tNoneBakeTestRule.getCpX()||(null == tNoneBakeTestRule.getCpY())){
                    throw new QuException(1,"没有中心点数据无法修改");
                }
            }
            /*if(noneBakeRuleId!=null){
                //删除中间表数据通过非正常烤测试数据ID
                this.tNoneBakeTestRuleDao.deleteTOutputRequireNbakeRuleById(noneBakeRuleId);
            }*/
            //删除通过出货要求ID
            this.tNoneBakeTestRuleDao.deleteTOutputRequireNbakeRuleByOutputRequireId
                    (tOutputRequireNbakeRule.getOutputRequireId());
            //新增新的非正常烤规则
            this.tNoneBakeTestRuleDao.insertSelective(tNoneBakeTestRule);
            tOutputRequireNbakeRule.setNoneBakeRuleId(tNoneBakeTestRule.getId());
            //新增中间表
            this.tNoneBakeTestRuleDao.insertTOutputRequireNbakeRule(tOutputRequireNbakeRule);
        }

        return ResultUtils.success();
    }

}
