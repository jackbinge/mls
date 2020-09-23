package com.wiseq.cn.ykAi.service.serviceimpl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.OperationUtil;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.*;
import com.wiseq.cn.utils.ListUtil;
import com.wiseq.cn.ykAi.dao.*;
import com.wiseq.cn.ykAi.service.TAiModelService;
import jxl.biff.StringHelper;
import org.apache.logging.log4j.util.Strings;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        2019/11/7      jiangbailing      原始版本
 * 文件说明:基础库-配比库
 */
@Service
public class TAiModelServiceImpl implements TAiModelService {

    @Autowired
    private TAiModelMapper tAiModelMapper;
    @Autowired
    private TChipDao tChipDao;
    @Autowired
    private BsFormulaUpdateLogDao bsFormulaUpdateLogDao;
    @Autowired
    private BsFormulaUpdateLogDtlDao bsFormulaUpdateLogDtlDao;
    @Autowired
    private TModelBomChipWlRankDao tModelBomChipWlRankDao;
    @Autowired
    private TBomDao tBomDao;


    /**
     * 配比首页列表
     * @param spec
     * @param processType
     * @param pageNum
     * @param pageSize
     * @return
     */
    @Override
    public Result findModelList(String spec, Byte processType, Integer pageNum, Integer pageSize){
        PageHelper.startPage(pageNum,pageSize);
        PageInfo pageInfo = new PageInfo(this.tAiModelMapper.findModelList(spec,processType));
        return ResultUtils.success(pageInfo);
    }


    /**
     * 通过BOMid获取芯片列表
     * @param id
     * @return
     */
    @Override
    public Result findChipMixByTypeMachineId(Long id){
        return  ResultUtils.success(this.tChipDao.findChipMixByTbomId(id));
    }


    /**
     *新增生产搭配
     * @param record
     * @return
     */
   /* @Override
    @Transactional
    public Result addProductCollocation(TAiModel record) throws QuException {
        if(record == null){
            return ResultUtils.error(2,"数据不完整无法创建");
        }
        if(record != null){
            if(null == record.getTypeMachineId()){
                return ResultUtils.error(2,"没有机种信息无法创建");
            }
            if(null == record.getColorRegionId()){
                return ResultUtils.error(2,"没有色容差信息无法创建");
            }
            if(null == record.getOutputRequireMachineId()){
                return ResultUtils.error(2,"没有出货要求信息无法创建");
            }
        }

        //新增生产搭配缺少bom信息的表
        this.tAiModelMapper.insertSelective(record);

        //单层
        TBom bom = record.getTBoms().get(0);
        List<Long> newchipRankIdList = record.getTChipWlRankList();
        //获取可能相同的生产搭配
        List<Long> oldmodeIdList = this.tAiModelMapper.findAiModelIdList(record.getTypeMachineId(),record.getOutputRequireMachineId(),bom.getId());
        for (Long modelId:
        oldmodeIdList) {
            //获取它的芯片波段集合再进行比较
            List<Long> oldchipRankIdList = this.tAiModelMapper.findAiModelBomchipRankIdList(modelId);
            if(ListUtil.isListEqual(newchipRankIdList,oldchipRankIdList)){
                throw new QuException(1,"生产搭配创建重复");
            }
        }

        TModelBom tModelBom = new TModelBom();
        tModelBom.setBomId(bom.getId());
        tModelBom.setModelId(record.getId());
        //生产搭配和bom的关系表
        tAiModelMapper.insertTModelBom(tModelBom);
        Long modelBomId = tModelBom.getId();
        //新增其对应的芯片波段
        tModelBomChipWlRankDao.insert(newchipRankIdList,modelBomId);
        return ResultUtils.success();

    }*/

    /**
     *新增生产搭配 有model_id 返回的情况 双层校验待定
     * @param record
     * @return
     */
    @Override
    @Transactional
    public Result addProductCollocationReturnId(TAiModel record){
        if(record == null){
            return ResultUtils.error(2,"数据不完整无法创建");
        }
        if(record != null){
            if(null == record.getTypeMachineId()){
                return ResultUtils.error(2,"没有机种信息无法创建");
            }
            if(null == record.getColorRegionId()){
                return ResultUtils.error(2,"没有色容差信息无法创建");
            }
            if(null == record.getOutputRequireMachineId()){
                return ResultUtils.error(2,"没有出货要求信息无法创建");
            }
        }


        //新的芯片波段数据
        List<Long> newchipRankIdList = record.getTChipWlRankList();
        Long bomId = record.getTBoms().get(0).getId();
        Long typeMachineId = record.getTypeMachineId();
        Long colorRegionId = record.getColorRegionId();
        Long outputRequireMachineId = record.getOutputRequireMachineId();


        //获取可能相同的生产搭配
        List<Long> oldmodeIdList = this.tAiModelMapper.findAiModelIdList(typeMachineId,outputRequireMachineId,bomId);
        for (Long modelId:
                oldmodeIdList) {
            //获取它的芯片波段集合再进行比较
            List<Long> oldchipRankIdList = this.tAiModelMapper.findAiModelBomchipRankIdList(modelId);
            if(ListUtil.isListEqual(newchipRankIdList,oldchipRankIdList)){
                return ResultUtils.error(1,"生产搭配已存在");
            }
        }

        //先新增t_ai_model
        this.tAiModelMapper.insertSelective(record);
        TBom bom = record.getTBoms().get(0);

        TModelBom tModelBom = new TModelBom();
        tModelBom.setBomId(bom.getId());
        tModelBom.setModelId(record.getId());
        //生产搭配和bom的关系表t_model_bom
        tAiModelMapper.insertTModelBom(tModelBom);
        Long modelBomId = tModelBom.getId();
        //新增其对应的芯片波段
        tModelBomChipWlRankDao.insert(newchipRankIdList,modelBomId);

        return ResultUtils.success(record.getId());

    }

    private Byte colorToleranceOutputKind = 0;//色容差类型
    private Byte OuputRatioOutputKind = 1;//出货比例
    private Byte centerPointOutputKind = 2;//出货要求中心点类型


    /**
     * 调整出货比例中心点
     * 包含算法调用
     *//*
    @Override
    public Result  adjustmentCentterPoint(TAiModel record){
        Result result = addProductCollocationReturnId(record);

        if(result.getCode()!=0||result.getCode()!=ResultEnum.MODEl_REPEAT.getState()){
            return result;
        }
        Long modelId=null;
        modelId = (long)result.getData();
        TAIModelDtl taiModelDtl =  this.tAiModelMapper.getOneMoldeByModelId(modelId);
        if(taiModelDtl.getOutputKind()==centerPointOutputKind){
            Integer num = this.tAiModelMapper.selectAiModelByOutputId(record.getOutputRequireMachineId(),modelId);
            if(num>0){
                return result;
            }else{
                MLSAiInterface mlsAiInterface = new MLSAiInterface();
                Result<AiCenterPoint> res = mlsAiInterface.centerpointMethod(modelId,record.getOutputRequireMachineId(),0l);
                if(res.getCode()==0){
                    AiCenterPoint aiCenterPoint = res.getData();
                    this.tAiModelMapper.updateOutputRequireCPXY(aiCenterPoint.getCenter_x(),aiCenterPoint.getCenter_y(),record.getOutputRequireMachineId());
                }else{
                    return res;
                }

            }
        }
        return result;
    }*/

    /**
     * 获取生产搭配列表
     * @param typeMachineId
     * @param outputRequireMachineCode
     * @param bomCode
     * @return
     */
    @Override
    public Result findMoldeList(Long typeMachineId,
                                String outputRequireMachineCode,
                                String bomCode){
        //生产搭配列表
        List<TAIModelDtl> taiModelDtlList = this.tAiModelMapper.findMoldeList(typeMachineId, outputRequireMachineCode, bomCode);

        for (TAIModelDtl t:
         taiModelDtlList) {
            int index = 0;
            //bom列表
            List<TBom> tBomList = this.tAiModelMapper.findBomByModelId(t.getId());

           /* for (TBom tempBom:
                 tBomList) {
                List<TBomChip>  chipList = tBomDao.getChipList(tempBom.getId());
                tempBom.setChipList(chipList);
            }*/
            List<TModelFormula> tModelFormulas = this.tAiModelMapper.findTModelFormula(t.getId());
            //得到耗用
            BsTaskServiceImpl bsTaskService = new BsTaskServiceImpl();
            bsTaskService.getConsumption(tModelFormulas);

            for (TModelFormula t2:
              tModelFormulas) {
                if(null==t2.getGlueAMaterial()){
                    TMaterialFormula gluATModelFormula = this.tAiModelMapper.findMaterialGlueARatioByBomId(t2.getBomId());
                    t2.setGlueAMaterial(gluATModelFormula);
                }
                if(null==t2.getGlueBMaterial()){
                    TMaterialFormula gluBTModelFormula = this.tAiModelMapper.findMaterialGlueBRatioByBomId(t2.getBomId());
                    t2.setGlueBMaterial(gluBTModelFormula);
                }
                if(null==t2.getAntiStarchMaterial()){
                    TMaterialFormula antiStarchTModelFormula = this.tAiModelMapper.findMaterialAntiStarchRaitoByBomId(t2.getBomId());
                    t2.setAntiStarchMaterial(antiStarchTModelFormula);
                }
                if(null==t2.getDiffusionPowderMaterial()){
                    TMaterialFormula diffusionPowder = this.tAiModelMapper.findMaterialDiffusionPowderRaitoByBomId(t2.getBomId());
                    t2.setDiffusionPowderMaterial(diffusionPowder);
                }
                List<TMaterialFormula> tPhosphorslist = t2.getTPhosphors();
                if(tPhosphorslist !=null && tPhosphorslist.size()>0){
                    //bom中的坑沉淀粉
                    List<TPhosphor> list= this.tAiModelMapper.selectPhosphorByBomIdOrderBy(t2.getBomId(),tPhosphorslist);
                    tBomList.get(index).setTPhosphors(list);
                }
                index ++;
            }
            List<TColorRegionDtl> colorRegionDtls= this.tAiModelMapper.outputRequiremendtlsByOutRequireId(t.getOutputRequireMachineId());
            t.setBomList(tBomList);
            t.setTModelFormulas(tModelFormulas);
            t.setColorRegionDtls(colorRegionDtls);
        }
        return  ResultUtils.success(taiModelDtlList);
    }





    /**
     * 新增配比过程
     * 1.配比详情表新增
     * 2.配比变更日志表新增
     * 3.配比变更日志详情表 - 批量新增
     * 4.获取机种的目标参数
     * 5.新增配比对应的目标参数
     */
    @Transactional
    @Override
    public Result addModelFormula(EditTModelFormulaForPage editTModelFormulaForPage){
        List<TModelFormulaForTables> tModelFormulaForTables = editTModelFormulaForPage.getTModelFormulaForTables();
        //1.配比详情表新增
        for (TModelFormulaForTables t :
        tModelFormulaForTables) {
            this.tAiModelMapper.insertModelFormulaSelective(t);
        }

        //记录变更记录
        BsFormulaUpdateLog record = editTModelFormulaForPage.getBsFormulaUpdateLog();

        //2.配比变更日志表新增
        this.bsFormulaUpdateLogDao.insertSelective(record);


        List<BsFormulaUpdateLogDtl> list  =  new ArrayList<>();
        for (TModelFormulaForTables t:
        tModelFormulaForTables) {
            //具体的修改详情
            BsFormulaUpdateLogDtl recordDtl = new BsFormulaUpdateLogDtl();
            recordDtl.setMaterialClass(t.getMaterialClass());
            recordDtl.setModelBomId(t.getModelBomId());
            recordDtl.setFormulaUpdateLogId(record.getId());
            recordDtl.setMaterialId(t.getMaterialId());
            recordDtl.setRatio(t.getRatio());
            list.add(recordDtl);
        }

        //3.配比变更日志详情表 - 批量新增
        this.bsFormulaUpdateLogDtlDao.batchInsert(list);
        //4.获取机种的目标参数
        Long modeBomId = record.getModelBomId();
        Long bsFormulaUpdateLogId = record.getId();

        BsFormulaTargetParameter bsFormulaTargetParameter = this.bsFormulaUpdateLogDtlDao.selectTypeMachineTargetParameterByModelBomId(modeBomId);
        bsFormulaTargetParameter.setBsFormulaUpdateLogId(bsFormulaUpdateLogId);
        //5.新增配比对应的目标参数
        this.bsFormulaUpdateLogDtlDao.insertTargetParameter(bsFormulaTargetParameter);
        return ResultUtils.success();
    }


    /**
     * 修改配比
     * 1.配比详情表修改
     * 2.配比变更日志表新增
     * 3.配比变更日志详情表 - 批量新增
     * 4.获取机种的目标参数
     * 5.新增配比对应的目标参数
     */
    @Transactional
    @Override
    public Result updateModelFormula(EditTModelFormulaForPage editTModelFormulaForPage){
        List<TModelFormulaForTables> tModelFormulaForTables = editTModelFormulaForPage.getTModelFormulaForTables();
        //1.先修改配比详情表
        this.tAiModelMapper.updateBatchModelFormula(tModelFormulaForTables);


        //记录变更记录
        BsFormulaUpdateLog record = editTModelFormulaForPage.getBsFormulaUpdateLog();
        //2.配比变更日志表新增
        this.bsFormulaUpdateLogDao.insertSelective(record);

        List<BsFormulaUpdateLogDtl> list  =  new ArrayList<>();
        for (TModelFormulaForTables t:
                tModelFormulaForTables) {
            //修改配比详情表
            //this.tAiModelMapper.updateModelFormula(t);
            //具体的修改详情
            BsFormulaUpdateLogDtl recordDtl = new BsFormulaUpdateLogDtl();
            recordDtl.setMaterialClass(t.getMaterialClass());
            recordDtl.setModelBomId(t.getModelBomId());
            recordDtl.setFormulaUpdateLogId(record.getId());
            recordDtl.setMaterialId(t.getMaterialId());
            recordDtl.setRatio(t.getRatio());
            list.add(recordDtl);
        }

        //3.配比日志详情表新增
        this.bsFormulaUpdateLogDtlDao.batchInsert(list);
        //4.获取机种的目标参数
        Long modeBomId = record.getModelBomId();
        Long bsFormulaUpdateLogId = record.getId();

        BsFormulaTargetParameter bsFormulaTargetParameter = this.bsFormulaUpdateLogDtlDao.selectTypeMachineTargetParameterByModelBomId(modeBomId);
        bsFormulaTargetParameter.setBsFormulaUpdateLogId(bsFormulaUpdateLogId);
        //5.新增配比对应的目标参数
        this.bsFormulaUpdateLogDtlDao.insertTargetParameter(bsFormulaTargetParameter);
        return ResultUtils.success();
    }

    /**
     * 通过modelId删除这条生产搭配
     * @param id
     * @return
     */
    @Override
    public Result deleteModelByPrimaryKey(Long id){

        int count= this.tAiModelMapper.findTaskNumWithThisModel(id);
        if(count!=0){
            return ResultUtils.error(1,"此生产搭配已经有工单使用，无法删除");
        }
        //删除
        this.tAiModelMapper.deleteByPrimaryKey(id);
        return ResultUtils.success();
    }

    @Override
    public  Result selectFormulaUpdteLog(Long modelBomId) {
        return ResultUtils.success(bsFormulaUpdateLogDao.selectFormulaUpdteLog(modelBomId ));
    }


    @Override
    public List<Map<String, Object>> selectAiModelChip(Long modelId) {
        List<Map<String, Object>> chipList = this.tModelBomChipWlRankDao.selectAiModelChipInfo(modelId);
        for (Map<String, Object> temp1:
         chipList) {
              String modelBomChipWlRankIdList = (String)temp1.get("modelBomChipWlRankIdList");
              List<Map<String, Object>> chipWlRankList = tModelBomChipWlRankDao.selectChipWlRankIdList(modelBomChipWlRankIdList);
              temp1.put("chipWlRankList",chipWlRankList);
        }

        return chipList;
    }


    //获取建立此配比时的目标参数
    @Override
    public BsFormulaTargetParameter selectRatioTargetParameter(Long bsFormulaUpdateLogId){
        return this.bsFormulaUpdateLogDtlDao.selectRatioTargetParameter(bsFormulaUpdateLogId);
    }


    /**
     * 校验bom是否符合当前的显色指数要求
     * 1.先获取RA和R9
     * 2.再获取波段最长的（或者时波段列表）
     * 3.然后根据规则去筛选
     */
    @Override
    public String checkoutAiModel(Long modelId){
        Double differenceValue = 3d;
        //获取目标参数
        TargetParameter targetParameter = this.tAiModelMapper.getTypeMachineTargetParameterByModelId(modelId);
        //获取荧光粉峰值
        List<PhosphorPeakWavelength> peakWavelengthList = this.tAiModelMapper.getBomPhosphorPeakWavelengthList(modelId);
        Double raTarget = targetParameter.getRaTarget();
        Double raMin = targetParameter.getRaMin();
        Double raMax = targetParameter.getRaMax();
        Double r9 = targetParameter.getR9();
        Double max = peakWavelengthList.parallelStream().mapToDouble(p -> p.getPeakWavelength()).max().getAsDouble();//取得波长最大的

        String strpeakDifferenceException = "";
        String raException = "";
        for (int i = 0; i < peakWavelengthList.size() - 1; i++) {
            for (int j = i + 1; j < peakWavelengthList.size(); j++) {
                //两个波峰想减得绝对值
                Double n = Math.abs(OperationUtil.subDouble(peakWavelengthList.get(i).getPeakWavelength(),peakWavelengthList.get(j).getPeakWavelength()));
                if(n <= differenceValue){
                    strpeakDifferenceException = "荧光粉" + peakWavelengthList.get(i).getSpec() + "与" + peakWavelengthList.get(j).getSpec()+"的峰值波长差异过小，" +
                            "是否优化？";
                    break;
                }
            }
        }
        if(raTarget == null){
            raException = "";
        }else {
            if((raMax >= 70 && raMax < 80) && (raMin >= 70 && raMin < 80)){

                if(!(max >= 610 && max < 625)){
                    raException = "当前荧光粉组合不适用于" + raTarget + "显指系列，";
                }

               /* for (Double temp1:
                        peakWavelengthList) {
                     if(!(temp1 >= 610 && temp1 < 625)){
                        return false;
                     }
                }*/
                //return true;
            }else if((raMax >= 80 && raMax <= 85) && (raMin >= 80 && raMin <= 85)){
                if(!(max >= 620 && max < 635)){
                    raException = "当前荧光粉组合不适用于" + raTarget + "显指系列，";
                }

               /* for (Double temp1:
                        peakWavelengthList) {
                    if(!(temp1 >= 620 && temp1 < 630)){
                        return false;
                    }
                }*/
                //return  true;
            }else if(raMax > 85  && raMin > 85   ){
                if(!(max > 625 )){
                    raException = "当前荧光粉组合不适用于" + raTarget + "显指系列，";
                }

               /* for (Double temp1:
                        peakWavelengthList) {
                    if(!(temp1 > 626 )){
                        return false;
                    }
                }*/
                //return  true;
            }

        }
        if(Strings.isEmpty(strpeakDifferenceException) && !Strings.isEmpty(raException)){
            strpeakDifferenceException = "是否优化？";
        }
        return raException + strpeakDifferenceException;
    }
}
