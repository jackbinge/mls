package com.wiseq.cn.ykAi.service.serviceimpl;
import java.math.BigDecimal;
import	java.util.Random;


import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.exception.QuException;
import com.wiseq.cn.commons.utils.NumberUtil;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.commons.utils.RoundTool;
import com.wiseq.cn.entity.ykAi.*;
import com.wiseq.cn.httpRequest.MLSAiInterface;
import com.wiseq.cn.ykAi.dao.TOutputRequirementsDao;
import com.wiseq.cn.ykAi.dao.TOutputRequirementsDtlMapper;
import com.wiseq.cn.ykAi.dao.TTypeMachineDao;
import com.wiseq.cn.ykAi.service.TOutputRequirementsService;
import io.swagger.models.auth.In;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class TOutputRequirementsServiceImpl implements TOutputRequirementsService {
    @Autowired
    private TOutputRequirementsDao tOutputRequirementsDao;
    @Autowired
    private TOutputRequirementsDtlMapper tOutputRequirementsDtlMapper;
    @Autowired
    private TTypeMachineDao tTypeMachineDao;




    private Byte colorToleranceOutputKind = 0;//色容差类型
    private Byte OuputRatioOutputKind = 1;//出货比例
    private Byte centerPointOutputKind = 2;//出货要求中心点类型

    private Byte TYshape = 0;//椭圆
    private Byte SBXShape = 1;//方形

    /**
     * 通过机种获取其出货要求列表
     * @param typeMachineId
     * @param outputKind
     * @param isTemp
     * @param code
     * @return
     */
     @Override
     public List<TOutputRequirements> selectByTypeMachineId(Long typeMachineId,
                                                            Byte outputKind,
                                                            Boolean isTemp, String code){

         List<TOutputRequirements> tOutputRequirementsList=this.tOutputRequirementsDao.selectByTypeMachineId(typeMachineId, outputKind, isTemp, code);
         for (TOutputRequirements t :
            tOutputRequirementsList) {
             Byte outPutKind = t.getOutputKind();
             List<TOutputRequirementsDtl> tOutputRequirementsDtlList = this.tOutputRequirementsDao.findTOutputRequirementsDtls(t.getId());

            /* if(outPutKind.equals(centerPointOutputKind)){
                 if(tOutputRequirementsDtlList.size()> 0){
                     TOutputRequirementsDtl tOutputRequirementsDtl = tOutputRequirementsDtlList.get(0);
                     tOutputRequirementsDtl.setTColorRegionDtl();
                 }
             }*/
             t.setTOutputRequirementsDtls(tOutputRequirementsDtlList);
         }
         return tOutputRequirementsList;
     }

    /**
     * 获取单个出货要求
     * @param outputId
     * @return
     */
     @Override
     public Result selectTOutputRequirementsByPK(Long outputId){
         TOutputRequirements tOutputRequirements = this.tOutputRequirementsDao.selectByPKWithDelete(outputId);
         tOutputRequirements.setTOutputRequirementsDtls(this.tOutputRequirementsDao.findTOutputRequirementsDtls(tOutputRequirements.getId()));
         return ResultUtils.success(tOutputRequirements);
     }

    /**
     * 获取单个出货要求
     * @param outputId
     * @return
     */
    @Override
    public TOutputRequirements selectTOutputRequirementsByPKNOResult(Long outputId){
        TOutputRequirements tOutputRequirements = this.tOutputRequirementsDao.selectByPKWithDelete(outputId);
        tOutputRequirements.setTOutputRequirementsDtls(this.tOutputRequirementsDao.findTOutputRequirementsDtls(tOutputRequirements.getId()));
        return tOutputRequirements;
    }

    /**
     * 获取色容差列表
     * @param typeMachineId
     * @return
     */
    @Override
    public List<TColorTolerance> findTColorTolerance(Long typeMachineId){
        return this.tOutputRequirementsDao.findTColorTolerance(typeMachineId);
     }


    /**
     * 色块
     * @param typeMachineId
     * @return
     */
    @Override
     public List<TColorRegionSK> findTColorRegionSK(Long typeMachineId){
        return this.tOutputRequirementsDao.findTColorRegionSKs(typeMachineId);
     }


    /**
     * 编辑出货要求
     * @param tOutputRequirementsAll
     * @return
     */
    @Override
    @Transactional
    public Result updateOutputRequirements(TOutputRequirementsAll tOutputRequirementsAll) throws QuException{
        List<TOutputRequirements> addlist=tOutputRequirementsAll.getAddList();
        List<TOutputRequirements>  deleteList=tOutputRequirementsAll.getDeleteList();
        //出货要求
        List<TOutputRequirements> updateList=tOutputRequirementsAll.getUpdateList();


        TTypeMachine record = new TTypeMachine();
        record.setId(tOutputRequirementsAll.getTypeMachineId());
        if(tOutputRequirementsAll.getRaMax()!=null&&tOutputRequirementsAll.getRaMin()!=null){
            record.setRaMax(tOutputRequirementsAll.getRaMax());
            record.setRaMin(tOutputRequirementsAll.getRaMin());
            //修改显色指数
            tTypeMachineDao.updateByPrimaryKeySelective(record);
        }


        boolean iscolorRegion = false;
        for (TOutputRequirements  t :
         addlist) {
            this.tOutputRequirementsDao.insertSelective(t);
            if(t.getOutputKind().equals(colorToleranceOutputKind)){
                iscolorRegion = true;
            }
            List<TOutputRequirementsDtl> tOutputRequirementsDtlList = t.getTOutputRequirementsDtls();
            if(tOutputRequirementsDtlList == null || tOutputRequirementsDtlList.size() > 0){
                new QuException(1,"没有色区详情数据无法新增");
            }
            for (TOutputRequirementsDtl t2:
                    tOutputRequirementsDtlList ) {
                t2.setOutputRequireId(t.getId());
                if(iscolorRegion){
                    TColorTolerance tColorTolerance =  this.tOutputRequirementsDao.findAllTColorToleranceById(t2.getColorRegionId());
                    if(tColorTolerance.getShape()==TYshape){
                        t2.setCpX(tColorTolerance.getX());
                        t2.setCpY(tColorTolerance.getY());
                    }else{
                        Double totalx = tColorTolerance.getX1()+tColorTolerance.getX2()+tColorTolerance.getX3()+tColorTolerance.getX4();
                        Double totaly = tColorTolerance.getY1()+tColorTolerance.getY2()+tColorTolerance.getY3()+tColorTolerance.getY4();
                        Double endX = totalx/4.0d;
                        Double endY = totaly/4.0d;
                        endX = RoundTool.round(endX,5, BigDecimal.ROUND_HALF_UP);
                        endY = RoundTool.round(endY,5, BigDecimal.ROUND_HALF_UP);
                        t2.setCpX(endX);
                        t2.setCpY(endY);
                    }
                }
                this.tOutputRequirementsDtlMapper.insertSelective(t2);
            }
            iscolorRegion = false;
        }

        for (TOutputRequirements  t :
                deleteList) {
            this.tOutputRequirementsDao.deleteByPrimaryKey(t.getId());
        }

        for (TOutputRequirements  t :
                updateList) {
            //机种库出货要求保存更新
            this.tOutputRequirementsDao.updateByPrimaryKeySelective(t);

            List<TOutputRequirementsDtl> dtls = t.getTOutputRequirementsDtls();

            //判断如果出货要求类型是出货比例，先删除在新增。否则修改
            for (TOutputRequirementsDtl  dd : dtls) {
                dd.setOutputRequireId(t.getId());
                if(dd.getRatioType() != null && !"".equals(dd.getRatioType())){
                    //删除出货比例
                    this.tOutputRequirementsDtlMapper.deleteByORidAndCRid(dd.getOutputRequireId(),dd.getColorRegionId());
                }
            }
            for (TOutputRequirementsDtl  tt : dtls) {
                //tt.setId(t.getId());
                tt.setOutputRequireId(t.getId());

                if(tt.getRatioType() != null && !"".equals(tt.getRatioType())){
                    //新增
                    this.tOutputRequirementsDtlMapper.insert(tt);
                }else {
                    //其他出货要求类型修改
                    this.tOutputRequirementsDao.updateDtlByPrimaryKeySelective(tt);
                }


            }


        }

        return ResultUtils.success();
    }


    /**
     * 获取所有的色块信息包含已删除的
     * @param typeMachineId
     * @return
     */
    @Override
    public Result findAllTColorRegionSKs(Long typeMachineId){
        return  ResultUtils.success
                (this.tOutputRequirementsDao.findAllTColorRegionSKs(typeMachineId));
    }

    /**
     * 获取这个机种所有的色块信息
     * @param typeMachineId
     * @return
     */
    @Override
    public Result findAllTColorTolerance(Long typeMachineId){
        return ResultUtils.success
                (this.tOutputRequirementsDao.findAllTColorTolerance(typeMachineId));
    }


    /**
     * 新建出货要求时拟合中心点
     * @param newoutputRequireId
     * @return
     * @throws QuException
     */
    private AiCenterPoint centerpointMethod(Long newoutputRequireId) throws QuException {
        Long modelId = 0l;
        Long outputRequireId = null;
        Long fileId = 0l;
        MLSAiInterface mlsAiInterface = new MLSAiInterface();
        Result<AiCenterPoint> aiCenterPointResult = mlsAiInterface.centerpointMethod(modelId,outputRequireId,fileId);
        if(aiCenterPointResult.getCode()==1){
            new QuException(1,"目标中心点拟合失败");
        }
        AiCenterPoint aiCenterPoint = aiCenterPointResult.getData();
        return aiCenterPoint;
    }


    /**
     * 拟合中心点
     * @return
     * @throws QuException
     */
    @Override
    public Result centerpointMethod(String jsonStr) throws QuException{
        MLSAiInterface mlsAiInterface = new MLSAiInterface();
        Result result= mlsAiInterface.centerpointMethodFirst(jsonStr);
        return result;
    }

    @Override
    public Result deleteOutputRequiremet(Long outputId) {
        this.tOutputRequirementsDao.deleteByPrimaryKey(outputId);
        return ResultUtils.success();
    }
}
