package com.wiseq.cn.ykAi.service.serviceimpl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.*;
import com.wiseq.cn.commons.exception.QuException;
import com.wiseq.cn.commons.utils.Convert;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.*;
import com.wiseq.cn.httpRequest.MLSAiInterface;
import com.wiseq.cn.utils.BsEqptGuleDosage_DISTINCT;
import com.wiseq.cn.utils.ListUtil;
import com.wiseq.cn.ykAi.dao.*;
import com.wiseq.cn.ykAi.dao.TAlgorithmModelDao;
import com.wiseq.cn.ykAi.service.BsTaskService;
import com.wiseq.cn.ykAi.service.TAiModelService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

import static java.util.stream.Collectors.groupingBy;
import static java.util.stream.Collectors.toList;


/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/21     jiangbailing      原始版本
 * 文件说明: 工单状态  工单状态在除了关闭工单，修改配比和修改配方不需要复制之外其它情况都修要复制配比和点胶量
 */
@Service
public class BsTaskServiceImpl implements BsTaskService {
    public static final Logger log = LoggerFactory.getLogger(BsTaskServiceImpl.class);
    @Autowired
    private BsTaskStateDao bsTaskStateDao;

    @Autowired
    private TAiModelMapper tAiModelMapper;

    @Autowired
    private BsTaskFormulaDao bsTaskFormulaDao;

    @Autowired
    private BsEqptValveStateDao bsEqptValveStateDao;

    @Autowired
    private TAiModelService tAiModelService;

    @Autowired
    private BsTaskFormulaDtlDao bsTaskFormulaDtlDao;
    @Autowired
    private TOutputRequirementsDao tOutputRequirementsDao;
    @Autowired
    private  TModelBomChipWlRankDao tModelBomChipWlRankDao;

    @Autowired
    private TBomDao tBomDao;

    @Autowired
    BsZConsumptionDao bsZConsumptionDao;

    @Autowired
    TPhosphorDao tPhosphorDao;

    @Autowired
    TAlgorithmModelDao tAlgorithmModelDao;

    /**
     * 在制生产页面
     * -- 2020-05-23
     *    -- 增加 process_type = 0 只查询主流程
     * @param taskCode
     * @param type
     * @param groupId
     * @param typeMachineSpec
     * @param stateFlag
     * @param pageNum
     * @param pageSize
     * @return
     */
    @Override
    public Result InProductTaskList (
                                String taskCode,
                                Byte type,
                                Long groupId,
                                String typeMachineSpec,
                                Byte stateFlag,
                                Integer pageNum,
                                Integer pageSize){
        PageHelper.startPage(pageNum,pageSize);
        PageInfo pageInfo = new PageInfo(this.bsTaskStateDao.getMainProcessInProductTaskList(taskCode, type, groupId, typeMachineSpec, stateFlag));
        List<Map<String,Object>> lists = pageInfo.getList();
        for (Map<String,Object> t:
             lists) {
            //获取状态数据
           /* BsTaskState bsTaskState = this.bsTaskStateDao.getActiveTaskStateAllInfoWithFileIdList(t.getTaskId());
            String fileidList = bsTaskState.getFileidList();*/
           String fileidList = bsTaskStateDao.getTaskStateFileList((Long) t.get("taskStateId"));

            if(fileidList == null || "".equals(fileidList)){
                t.put("isNoJudged",false);
            }else {
                //获取没判定的数量
                Integer num = this.bsTaskStateDao.findNoJudgeNum(fileidList,null);
                if (num == 0) {
                    t.put("isNoJudged",false);
                } else {
                    t.put("isNoJudged",true);
                }
            }
        }
        return ResultUtils.success(pageInfo);
    }



    /**
     * 获取工单最新的阀体列表
     * @param taskStateId
     * @return
     */
    @Override
    public Result findTaskStateEqptValve(Long taskStateId){
        //BsTaskState taskState = this.bsTaskStateDao.getActiveTaskStateAllInfoWithFileIdList(taskId);
        List<BSTaskEqptValve>  bsTaskEqptValveList = this.bsEqptValveStateDao.findTaskStateEqptValve(taskStateId);
        bsTaskEqptValveList.forEach(o -> {
            Long eqptId = o.getEqptId();

        });
        String fileList = this.bsTaskStateDao.getTaskStateFileList(taskStateId);
        for (BSTaskEqptValve t:
        bsTaskEqptValveList) {
            for (EqptValveDosage t2:
             t.getEqptValveDosageList()) {
               //Integer num=  this.bsTaskStateDao.isNOJudgeFile(taskId,t2.getEqptValveId());
                //String fileList = taskState.getFileidList();
                if(fileList==null ||"".equals(fileList)){
                    t2.setIsNoJudaged(false);
                }else {
                    Integer num = this.bsTaskStateDao.findNoJudgeNum(fileList,t2.getEqptValveId());
                    if (num == 0) {
                        t2.setIsNoJudaged(false);
                    } else {
                        t2.setIsNoJudaged(true);
                    }
                }
            }
        }
        return ResultUtils.success(bsTaskEqptValveList);
    }


    /**
     * 获取工单详情之页面的配比
     * @param taskStateId
     * @return
     */
    @Override
    public Result judgeTaskFormulaList(Long taskStateId){
        log.info("当前方法的为  {获取工单详情之页面的配比}   {judgeTaskFormulaList}");
        //log.info("当前的工单taskId：{}", taskId);

        //TaskState taskState = this.bsTaskStateDao.getActiveTaskState(taskId);
        //Long taskStateId = taskState.getTaskStateId();
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);//表bs_task_state
        log.info("当前的工单taskStateId：{}", taskStateId);
        //Long modelId = taskState.getModelId();
        Long modelId = taskStateForDatabase.getModelId();//modelId:当前状态对应的算法模型
        //如果工单库里面有配比id:268,taskstateid:303,task_bom_id:64,modelId:70
        List<BsTaskFormula> bsTaskFormulaList = bsTaskFormulaDao.getTaskFormulaForTaskState(taskStateId);
        if(bsTaskFormulaList.size() > 0){
            log.info("当前的工单taskStateId：{}, {} ", taskStateId,"工单表中有与此状态相关的配比数据");
            return getOneMoldeByModelIdAndTaskStateId(modelId,taskStateId);
        }else{
            log.info("当前的工单taskStateId：{}, {} ", taskStateId,"工单表中没有与此状态相关的配比数据");
            //Result<TAIModelDtl> tAiModelResult = getOneMoldeByModelId(modelId);
            //查看配比库中有没有相关的配比
            Integer num = tAiModelMapper.findExitFormulaByModelId(modelId);
            if( num.equals(0) ){
                //如果没有则直接从材料表中获取
                return ResultUtils.success(getRatioFromMaterialTable(modelId));
            }
            TAIModelDtl taiModelDtl = getRatioFromModelFormula(modelId);
            List<TModelFormula>  tModelFormulaList = taiModelDtl.getTModelFormulas();

            tModelFormulaList.forEach(o -> {
                BsTaskFormula bsTaskFormula = new BsTaskFormula();
                bsTaskFormula.setTaskStateId(taskStateId);
                bsTaskFormula.setTaskBomId(o.getBomId());
                //新增工单状态对BOM表
                bsTaskFormulaDao.insertSelective(bsTaskFormula);

                //转换
                List<TMaterialFormula> temp = new ArrayList<>();
                TMaterialFormula diffusionPowderMaterial =  o.getDiffusionPowderMaterial();
                TMaterialFormula antiStarchMaterial = o.getAntiStarchMaterial();
                List<TMaterialFormula> tPhosphors = o.getTPhosphors();
                TMaterialFormula glueAMaterial = o.getGlueAMaterial();
                TMaterialFormula glueBMaterial = o.getGlueBMaterial();
                if(diffusionPowderMaterial != null){
                    temp.add(diffusionPowderMaterial);
                }else {
                    temp.add(antiStarchMaterial);
                }
                temp.add(glueAMaterial);
                temp.add(glueBMaterial);
                temp.addAll(tPhosphors);

                List<BsTaskFormulaDtl> bsTaskFormulaDtlListTemp =  temp.stream().map(t -> {
                    BsTaskFormulaDtl bsTaskFormulaDtl = new BsTaskFormulaDtl();
                    bsTaskFormulaDtl.setMaterialId(t.getMaterialId());
                    bsTaskFormulaDtl.setTaskFormulaId(bsTaskFormula.getId());
                    bsTaskFormulaDtl.setMaterialClass(t.getMaterialId().byteValue());
                    bsTaskFormulaDtl.setRatio(t.getRatio());
                    return bsTaskFormulaDtl;
                }).collect(toList());

                //新增配比详情表
                bsTaskFormulaDtlDao.batchInsert(bsTaskFormulaDtlListTemp);

            });

            return  ResultUtils.success(taiModelDtl);
        }
    }


    /**
     * 通过模型ID 和 工单状态ID 从配比数据库里面获取数据
     * @param modelId
     * @param taskStateId
     * @return
     */
    public Result<TAIModelDtl> getOneMoldeByModelIdAndTaskStateId(Long modelId,Long taskStateId){

        TAIModelDtl taiModelDtl = this.tAiModelMapper.getOneMoldeByModelId(modelId);


        if(taiModelDtl != null){
            int index = 0;
            List<TBom> tBomList = this.tAiModelMapper.findBomByModelId(taiModelDtl.getId());
            List<TModelFormula> tModelFormulas = this.tAiModelMapper.findTModelFormula(modelId);//2020/9/1 改动is_circular:0圆锥，1棱台

            //得到耗用
            getConsumption(tModelFormulas);

            for (TModelFormula t2:
                    tModelFormulas) {
                TMaterialFormula gluATModelFormula = this.bsTaskFormulaDao.getBsTaskFormulaGlueAByTaskFormulaId(taskStateId,t2.getBomId());//476,100
                t2.setGlueAMaterial(gluATModelFormula);

                TMaterialFormula gluBTModelFormula = this.bsTaskFormulaDao.getBsTaskFormulaGlueBByTaskFormulaId(taskStateId,t2.getBomId());
                t2.setGlueBMaterial(gluBTModelFormula);


                TMaterialFormula antiStarchTModelFormula = this.bsTaskFormulaDao.getBsTaskFormulaAntiStarchByTaskFormulaId(taskStateId,t2.getBomId());
                t2.setAntiStarchMaterial(antiStarchTModelFormula);


                TMaterialFormula diffusionPowder = this.bsTaskFormulaDao.getBsTaskFormulaDiffusionPowderTaskIdAndBomId(taskStateId,t2.getBomId());
                t2.setDiffusionPowderMaterial(diffusionPowder);

                List<TMaterialFormula> tPhosphorslist = this.bsTaskFormulaDao.getBsTaskFormulaPhosphorsByTaskFormulaId(taskStateId,t2.getBomId());
                t2.setTPhosphors(tPhosphorslist);
                if(tPhosphorslist != null && tPhosphorslist.size() > 0 ){
                    //bom中的荧光粉
                    List<TPhosphor> list= this.tAiModelMapper.selectPhosphorByBomIdOrderBy(t2.getBomId(),tPhosphorslist);
                    tBomList.get(index).setTPhosphors(list);
                }
                //是否有抗沉淀粉
                if(null!=t2.getAntiStarchMaterial()){
                    t2.setDiffusionPowderMaterial(null);
                }
                index++;
            }


            List<TColorRegionDtl> colorRegionDtls= this.tAiModelMapper.outputRequiremendtlsByOutRequireId(taiModelDtl.getOutputRequireMachineId());
            taiModelDtl.setBomList(tBomList);
            taiModelDtl.setTModelFormulas(tModelFormulas);
            taiModelDtl.setColorRegionDtls(colorRegionDtls);
            return ResultUtils.success(taiModelDtl);
        }
        return ResultUtils.error(1,"通过模型ID未获取对应的配方信息");
    }

    /**
     * 计算耗用 2020/9/3
     * @param
     * @return
     */
    public Result getConsumption(List<TModelFormula> tModelFormulas) {
    //public Result getConsumption(Long taskStateId) {
/*
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);//表bs_task_state
        log.info("当前的工单taskStateId：{}", taskStateId);
        //Long modelId = taskState.getModelId();
        Long modelId = taskStateForDatabase.getModelId();//modelId:当前状态对应的算法模型
        //如果工单库里面有配比id:268,taskstateid:303,task_bom_id:64,modelId:70
        List<BsTaskFormula> bsTaskFormulaList = bsTaskFormulaDao.getTaskFormulaForTaskState(taskStateId);


        TAIModelDtl taiModelDtl = this.tAiModelMapper.getOneMoldeByModelId(modelId);


        if(taiModelDtl != null){
            List<TModelFormula> tModelFormulas = this.tAiModelMapper.findTModelFormula(modelId);//2020/9/1 改动is_circular:0圆锥，1棱台
*/
            //得到耗用
            //getConsumption(tModelFormulas);
            ////////////////////////////////
        /*      param1        double comment '棱台底宽/底部直径',
                    param2        double comment '棱台底长/顶部直径',
                    param3        double comment '棱台顶长/圆台高度',
                    param4        double comment '棱台顶宽',
                    param5        double comment '棱台高',
            */

            //耗用计算costCalculation,抽取出单独的方法
            for (TModelFormula tt: tModelFormulas){

                Double ma;
                Double pa;
                //各材料配比a,b胶，抗沉淀粉/扩散粉（二选一，一般是抗沉淀粉），荧光粉
                if(tt.getGlueAMaterial() != null && tt.getGlueAMaterial().getRatio() != null ){
                    ma = tt.getGlueAMaterial().getRatio();
                    pa = tt.getGlueAMaterial().getDensity();
                }else{
                    //返回值类型 Result：
                    return ResultUtils.error(1,"请确认配比");
                }


                Double mb = 1.00;
                Double pb = 1.00;

                if(tt.getGlueBMaterial() != null && tt.getGlueBMaterial().getRatio() != null ){
                    mb = tt.getGlueBMaterial().getRatio();
                    pb = tt.getGlueBMaterial().getDensity();
                }

                Double mc = 1.00;
                Double pc = 1.00;

                if(tt.getAntiStarchMaterial() != null && tt.getAntiStarchMaterial().getRatio() != null ){
                    mc = tt.getAntiStarchMaterial().getRatio();
                    pc = tt.getAntiStarchMaterial().getDensity();
                }


                //Double md = tt.getDiffusionPowderMaterial().getRatio();
                //Double pd = tt.getDiffusionPowderMaterial().getDensity();


                //Map<String, Double> tpRatio = new LinkedHashMap<>();
                //Map<String, Double> tpDensity = new LinkedHashMap<>();
                List<Double> tpRatio = new ArrayList<>();
                List<Double> tpDensity = new ArrayList<>();


                //for(int i = 0; i < tt.getTPhosphors().size(); i++){
                //String spec = tt.getTPhosphors().get(i).getSpec();
                //tt.getTPhosphors().size() > 0
                if(tt.getTPhosphors() != null && !"".equals(tt.getTPhosphors()) ){
                    for(int i = 0; i < tt.getTPhosphors().size(); i++) {
                        Double mp = tt.getTPhosphors().get(i).getRatio();
                        if(mp == 0 || mp == 0.0){
                            mp = 9999.0;
                        }
                        tpRatio.add(mp);
                        Double pp = tt.getTPhosphors().get(i).getDensity();
                        tpDensity.add(pp);
                    }
                }else{
                    Double mp = 1.00;
                    Double pp = 1.00;
                    tpRatio.add(mp);
                    tpDensity.add(pp);
                }



                int length = tpRatio.size();
                Double[] mp = new Double[length];
                Double[] pp = new Double[length];
                for (int i = 0; i < length; i++)
                {
                    mp[i] =  tpRatio.get(i);
                    pp[i] =  tpDensity.get(i);
                }
                //Double[] mp = (Double[])tpRatio.toArray();
                //Double[] pp = (Double[]) tpDensity.toArray();

                List<ZConsumption> zConsumptions = new ArrayList<>();


                Byte isCircular ;
                //if(tt.getScaffold() != null && "".equals(tt.getScaffold())){
                if(tt.getScaffold() == null || "".equals(tt.getScaffold())){
                    return ResultUtils.error(1,"支架id为null");
                }
                if(tt.getScaffold().getIsCircular() != null && !"".equals(tt.getScaffold().getIsCircular())){
                    isCircular = tt.getScaffold().getIsCircular();
                }else{
                    isCircular = 2;
                    return ResultUtils.error(-1,"请确认配比");
                }
                //}else{
                //    isCircular = 2;
                //}
                //圆锥
                if(isCircular == 0){
                    Double r1 = tt.getScaffold().getParam1();
                    Double r2 = tt.getScaffold().getParam2();
                    Double hy = tt.getScaffold().getParam3();
                    //支架要求（胶体高度最大值）
                    Double h1 = tt.getGuleHigh().getGuleHightUsl();
                    Double h2 = tt.getGuleHigh().getGuleHightLsl();
                    //圆锥型体积
                    //Double V = Math.PI * (hy + h1) *0.1 * ((r1*0.1 / 2) ^ 2 + (r2*0.1/2) ^ 2 + (r1*0.1 / 2) * (r2*0.1/2)) / 3;
                    //平杯体积
                    Double VyFlat = Math.PI * (hy + h1) * 0.1 * (Math.pow((r1 * 0.1 / 2),2) + Math.pow((r2 * 0.1 / 2),2) + (r1 * 0.1 / 2) * (r2 * 0.1 / 2)) / 3;
                    //凹杯体积
                    Double VyConcave= Math.PI * (hy + h2) * 0.1 * (Math.pow((r1 * 0.1 / 2),2) + Math.pow((r2 * 0.1 / 2),2) + (r1 * 0.1 / 2) * (r2 * 0.1 / 2)) / 3;
                    //m:配比  p:密度


                    //TModelFormula tModelFormula1 = new TModelFormula();
                    //List<ZConsumption> zConsumptions = new ArrayList<>();

                    //圆锥平杯耗用
                    if(mp.length == 3){
                        Double xa = VyFlat / (1/pa + mb/ma/pb + mc/ma/pc + mp[0]/ma/pp[0] +  mp[1]/ma/pp[1] + mp[2]/ma/pp[2]) * 1000;
                        Double xb = VyFlat / (1/pb + ma/mb/pa + mc/mb/pc + mp[0]/mb/pp[0] +  mp[1]/mb/pp[1] + mp[2]/mb/pp[2]) * 1000;
                        Double xc = VyFlat / (1/pc + ma/mc/pa + mb/mc/pb + mp[0]/mc/pp[0] +  mp[1]/mc/pp[1] + mp[2]/mc/pp[2]) * 1000;
                        Double xp1 = VyFlat / (1/pp[0] + ma/mp[0]/pa + mb/mp[0]/pb + mc/mp[0]/pc + mp[1]/mp[0]/pp[1] + mp[2]/mp[0]/pp[2]) * 1000;
                        Double xp2 = VyFlat / (1/pp[1] + ma/mp[1]/pa + mb/mp[1]/pb + mc/mp[1]/pc + mp[0]/mp[1]/pp[0] + mp[2]/mp[1]/pp[2]) * 1000;
                        Double xp3 = VyFlat / (1/pp[2] + ma/mp[2]/pa + mb/mp[2]/pb + mc/mp[2]/pc + mp[0]/mp[2]/pp[0] + mp[1]/mp[2]/pp[1]) * 1000;

                        BigDecimal b1 = new BigDecimal(xa);
                        xa = b1.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b2 = new BigDecimal(xb);
                        xb = b2.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b3 = new BigDecimal(xc);
                        xc = b3.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b4 = new BigDecimal(xp1);
                        xp1 = b4.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b5 = new BigDecimal(xp2);
                        xp2 = b5.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b6 = new BigDecimal(xp3);
                        xp3 = b6.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();

                        ZConsumption zConsumption = new ZConsumption();
                        zConsumption.setGlueAMaterial(xa);
                        zConsumption.setGlueBMaterial(xb);
                        zConsumption.setAntiStarchMaterial(xc);
                        zConsumption.setTphosphors0(xp1);
                        zConsumption.setTphosphors1(xp2);
                        zConsumption.setTphosphors2(xp3);
                        zConsumptions.add(zConsumption);


                    }else if(mp.length == 2){
                        Double xa = VyFlat / (1/pa + mb/ma/pb + mc/ma/pc + mp[0]/ma/pp[0] +  mp[1]/ma/pp[1] ) * 1000;
                        Double xb = VyFlat / (1/pb + ma/mb/pa + mc/mb/pc + mp[0]/mb/pp[0] +  mp[1]/mb/pp[1] ) * 1000;
                        Double xc = VyFlat / (1/pc + ma/mc/pa + mb/mc/pb + mp[0]/mc/pp[0] +  mp[1]/mc/pp[1] ) * 1000;
                        Double xp1 = VyFlat / (1/pp[0] + ma/mp[0]/pa + mb/mp[0]/pb + mc/mp[0]/pc + mp[1]/mp[0]/pp[1]) * 1000;
                        Double xp2 = VyFlat / (1/pp[1] + ma/mp[1]/pa + mb/mp[1]/pb + mc/mp[1]/pc + mp[0]/mp[1]/pp[0]) * 1000;

                        BigDecimal b1 = new BigDecimal(xa);
                        xa = b1.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b2 = new BigDecimal(xb);
                        xb = b2.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b3 = new BigDecimal(xc);
                        xc = b3.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b4 = new BigDecimal(xp1);
                        xp1 = b4.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b5 = new BigDecimal(xp2);
                        xp2 = b5.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();

                        ZConsumption zConsumption = new ZConsumption();
                        zConsumption.setGlueAMaterial(xa);
                        zConsumption.setGlueBMaterial(xb);
                        zConsumption.setAntiStarchMaterial(xc);
                        zConsumption.setTphosphors0(xp1);
                        zConsumption.setTphosphors1(xp2);
                        zConsumptions.add(zConsumption);
                    }

                    //TModelFormula tModelFormula2 = new TModelFormula();
                    //List<ZConsumption> zConsumptions2 = new ArrayList<>();
                    //圆锥凹杯耗用
                    if(mp.length == 3){
                        Double xa = VyConcave / (1/pa + mb/ma/pb + mc/ma/pc + mp[0]/ma/pp[0] +  mp[1]/ma/pp[1] + mp[2]/ma/pp[2]) * 1000;
                        Double xb = VyConcave / (1/pb + ma/mb/pa + mc/mb/pc + mp[0]/mb/pp[0] +  mp[1]/mb/pp[1] + mp[2]/mb/pp[2]) * 1000;
                        Double xc = VyConcave / (1/pc + ma/mc/pa + mb/mc/pb + mp[0]/mc/pp[0] +  mp[1]/mc/pp[1] + mp[2]/mc/pp[2]) * 1000;
                        Double xp1 = VyConcave / (1/pp[0] + ma/mp[0]/pa + mb/mp[0]/pb + mc/mp[0]/pc + mp[1]/mp[0]/pp[1] + mp[2]/mp[0]/pp[2]) * 1000;
                        Double xp2 = VyConcave / (1/pp[1] + ma/mp[1]/pa + mb/mp[1]/pb + mc/mp[1]/pc + mp[0]/mp[1]/pp[0] + mp[2]/mp[1]/pp[2]) * 1000;
                        Double xp3 = VyConcave / (1/pp[2] + ma/mp[2]/pa + mb/mp[2]/pb + mc/mp[2]/pc + mp[0]/mp[2]/pp[0] + mp[1]/mp[2]/mp[1]) * 1000;
                        BigDecimal b1 = new BigDecimal(xa);
                        xa = b1.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b2 = new BigDecimal(xb);
                        xb = b2.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b3 = new BigDecimal(xc);
                        xc = b3.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b4 = new BigDecimal(xp1);
                        xp1 = b4.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b5 = new BigDecimal(xp2);
                        xp2 = b5.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b6 = new BigDecimal(xp3);
                        xp3 = b6.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();

                        ZConsumption zConsumption = new ZConsumption();
                        zConsumption.setGlueAMaterial(xa);
                        zConsumption.setGlueBMaterial(xb);
                        zConsumption.setAntiStarchMaterial(xc);
                        zConsumption.setTphosphors0(xp1);
                        zConsumption.setTphosphors1(xp2);
                        zConsumption.setTphosphors2(xp3);
                        zConsumptions.add(zConsumption);
                    }else if(mp.length == 2){
                        Double xa = VyConcave / (1/pa + mb/ma/pb + mc/ma/pc + mp[0]/ma/pp[0] +  mp[1]/ma/pp[1] ) * 1000;
                        Double xb = VyConcave / (1/pb + ma/mb/pa + mc/mb/pc + mp[0]/mb/pp[0] +  mp[1]/mb/pp[1] ) * 1000;
                        Double xc = VyConcave / (1/pc + ma/mc/pa + mb/mc/pb + mp[0]/mc/pp[0] +  mp[1]/mc/pp[1] ) * 1000;
                        Double xp1 = VyConcave / (1/pp[0] + ma/mp[0]/pa + mb/mp[0]/pb + mc/mp[0]/pc + mp[1]/mp[0]/pp[1]) * 1000;
                        Double xp2 = VyConcave / (1/pp[1] + ma/mp[1]/pa + mb/mp[1]/pb + mc/mp[1]/pc + mp[0]/mp[1]/pp[0]) * 1000;

                        BigDecimal b1 = new BigDecimal(xa);
                        xa = b1.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b2 = new BigDecimal(xb);
                        xb = b2.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b3 = new BigDecimal(xc);
                        xc = b3.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b4 = new BigDecimal(xp1);
                        xp1 = b4.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b5 = new BigDecimal(xp2);
                        xp2 = b5.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();

                        ZConsumption zConsumption = new ZConsumption();
                        zConsumption.setGlueAMaterial(xa);
                        zConsumption.setGlueBMaterial(xb);
                        zConsumption.setAntiStarchMaterial(xc);
                        zConsumption.setTphosphors0(xp1);
                        zConsumption.setTphosphors1(xp2);
                        zConsumptions.add(zConsumption);
                    }

                    tt.setZConsumptions(zConsumptions);

                }else if(isCircular == 1){
                    //棱台
                    Double b1 = tt.getScaffold().getParam1();
                    Double a1 = tt.getScaffold().getParam2();
                    Double a2 = tt.getScaffold().getParam3();
                    Double b2 = tt.getScaffold().getParam4();
                    Double hlt = tt.getScaffold().getParam5();

                    Double h1 = tt.getGuleHigh().getGuleHightUsl();
                    Double h2 = tt.getGuleHigh().getGuleHightLsl();

                    /*棱台体积 ：s1 = a1 * b1 * 0.01
                                 s2 = a2 * b2 * 0.01
                                 V = (h + h1) *0.1*(s1 + s2 + np.sqrt（开方）(s1 * s2)) / 3
                    */
                    Double s1 = a1 * b1 * 0.01;
                    Double s2 = a2 * b2 * 0.01;
                    //平杯体积
                    Double VltFlat = (hlt + h1) * 0.1 * (s1 + s2 + Math.sqrt(s1 * s2)) / 3;
                    //凹杯体积
                    Double VltConcave = (hlt + h2) * 0.1 * (s1 + s2 + Math.sqrt(s1 * s2)) / 3;


                    //TModelFormula tModelFormula1 = new TModelFormula();
                    //List<ZConsumption> zConsumptions1 = new ArrayList<>();
                    //棱台平杯耗用
                    if(mp.length == 3){
                        Double xa = VltFlat / (1/pa + mb/ma/pb + mc/ma/pc + mp[0]/ma/pp[0] +  mp[1]/ma/pp[1] + mp[2]/ma/pp[2]) * 1000;
                        Double xb = VltFlat / (1/pb + ma/mb/pa + mc/mb/pc + mp[0]/mb/pp[0] +  mp[1]/mb/pp[1] + mp[2]/mb/pp[2]) * 1000;
                        Double xc = VltFlat / (1/pc + ma/mc/pa + mb/mc/pb + mp[0]/mc/pp[0] +  mp[1]/mc/pp[1] + mp[2]/mc/pp[2]) * 1000;
                        Double xp1 = VltFlat / (1/pp[0] + ma/mp[0]/pa + mb/mp[0]/pb + mc/mp[0]/pc + mp[1]/mp[0]/pp[1] + mp[2]/mp[0]/pp[2]) * 1000;
                        Double xp2 = VltFlat / (1/pp[1] + ma/mp[1]/pa + mb/mp[1]/pb + mc/mp[1]/pc + mp[0]/mp[1]/pp[0] + mp[2]/mp[1]/pp[2]) * 1000;
                        Double xp3 = VltFlat / (1/pp[2] + ma/mp[2]/pa + mb/mp[2]/pb + mc/mp[2]/pc + mp[0]/mp[2]/pp[0] + mp[1]/mp[2]/pp[1]) * 1000;

                        BigDecimal b11 = new BigDecimal(xa);
                        xa = b11.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b22 = new BigDecimal(xb);
                        xb = b22.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b33 = new BigDecimal(xc);
                        xc = b33.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b4 = new BigDecimal(xp1);
                        xp1 = b4.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b5 = new BigDecimal(xp2);
                        xp2 = b5.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b6 = new BigDecimal(xp3);
                        xp3 = b6.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();

                        ZConsumption zConsumption = new ZConsumption();
                        zConsumption.setGlueAMaterial(xa);
                        zConsumption.setGlueBMaterial(xb);
                        zConsumption.setAntiStarchMaterial(xc);
                        zConsumption.setTphosphors0(xp1);
                        zConsumption.setTphosphors1(xp2);
                        zConsumption.setTphosphors2(xp3);
                        zConsumptions.add(zConsumption);
                    }else if(mp.length == 2){
                        Double xa = VltFlat / (1/pa + mb/ma/pb + mc/ma/pc + mp[0]/ma/pp[0] +  mp[1]/ma/pp[1] ) * 1000;
                        Double xb = VltFlat / (1/pb + ma/mb/pa + mc/mb/pc + mp[0]/mb/pp[0] +  mp[1]/mb/pp[1] ) * 1000;
                        Double xc = VltFlat / (1/pc + ma/mc/pa + mb/mc/pb + mp[0]/mc/pp[0] +  mp[1]/mc/pp[1] ) * 1000;
                        Double xp1 = VltFlat / (1/pp[0] + ma/mp[0]/pa + mb/mp[0]/pb + mc/mp[0]/pc + mp[1]/mp[0]/pp[1]) * 1000;
                        Double xp2 = VltFlat / (1/pp[1] + ma/mp[1]/pa + mb/mp[1]/pb + mc/mp[1]/pc + mp[0]/mp[1]/pp[0]) * 1000;

                        BigDecimal b11 = new BigDecimal(xa);
                        xa = b11.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b22 = new BigDecimal(xb);
                        xb = b22.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b33 = new BigDecimal(xc);
                        xc = b33.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b4 = new BigDecimal(xp1);
                        xp1 = b4.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b5 = new BigDecimal(xp2);
                        xp2 = b5.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();

                        ZConsumption zConsumption = new ZConsumption();
                        zConsumption.setGlueAMaterial(xa);
                        zConsumption.setGlueBMaterial(xb);
                        zConsumption.setAntiStarchMaterial(xc);
                        zConsumption.setTphosphors0(xp1);
                        zConsumption.setTphosphors1(xp2);
                        zConsumptions.add(zConsumption);
                    }

                    //TModelFormula tModelFormula2 = new TModelFormula();
                    //List<ZConsumption> zConsumptions2 = new ArrayList<>();
                    //棱台凹杯耗用
                    if(mp.length == 3){
                        Double xa = VltConcave / (1/pa + mb/ma/pb + mc/ma/pc + mp[0]/ma/pp[0] +  mp[1]/ma/pp[1] + mp[2]/ma/pp[2]) * 1000;
                        Double xb = VltConcave / (1/pb + ma/mb/pa + mc/mb/pc + mp[0]/mb/pp[0] +  mp[1]/mb/pp[1] + mp[2]/mb/pp[2]) * 1000;
                        Double xc = VltConcave / (1/pc + ma/mc/pa + mb/mc/pb + mp[0]/mc/pp[0] +  mp[1]/mc/pp[1] + mp[2]/mc/pp[2]) * 1000;
                        Double xp1 = VltConcave / (1/pp[0] + ma/mp[0]/pa + mb/mp[0]/pb + mc/mp[0]/pc + mp[1]/mp[0]/pp[1] + mp[2]/mp[0]/pp[2]) * 1000;
                        Double xp2 = VltConcave / (1/pp[1] + ma/mp[1]/pa + mb/mp[1]/pb + mc/mp[1]/pc + mp[0]/mp[1]/pp[0] + mp[2]/mp[1]/pp[2]) * 1000;
                        Double xp3 = VltConcave / (1/pp[2] + ma/mp[2]/pa + mb/mp[2]/pb + mc/mp[2]/pc + mp[0]/mp[2]/pp[0] + mp[1]/mp[2]/pp[1]) * 1000;

                        BigDecimal b11 = new BigDecimal(xa);
                        xa = b11.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b22 = new BigDecimal(xb);
                        xb = b22.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b33 = new BigDecimal(xc);
                        xc = b33.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b4 = new BigDecimal(xp1);
                        xp1 = b4.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b5 = new BigDecimal(xp2);
                        xp2 = b5.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b6 = new BigDecimal(xp3);
                        xp3 = b6.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();

                        ZConsumption zConsumption = new ZConsumption();
                        zConsumption.setGlueAMaterial(xa);
                        zConsumption.setGlueBMaterial(xb);
                        zConsumption.setAntiStarchMaterial(xc);
                        zConsumption.setTphosphors0(xp1);
                        zConsumption.setTphosphors1(xp2);
                        zConsumption.setTphosphors2(xp3);
                        zConsumptions.add(zConsumption);
                    }else if(mp.length == 2){
                        Double xa = VltConcave / (1/pa + mb/ma/pb + mc/ma/pc + mp[0]/ma/pp[0] +  mp[1]/ma/pp[1] ) * 1000;
                        Double xb = VltConcave / (1/pb + ma/mb/pa + mc/mb/pc + mp[0]/mb/pp[0] +  mp[1]/mb/pp[1] ) * 1000;
                        Double xc = VltConcave / (1/pc + ma/mc/pa + mb/mc/pb + mp[0]/mc/pp[0] +  mp[1]/mc/pp[1] ) * 1000;
                        Double xp1 = VltConcave / (1/pp[0] + ma/mp[0]/pa + mb/mp[0]/pb + mc/mp[0]/pc + mp[1]/mp[0]/pp[1]) * 1000;
                        Double xp2 = VltConcave / (1/pp[1] + ma/mp[1]/pa + mb/mp[1]/pb + mc/mp[1]/pc + mp[0]/mp[1]/pp[0]) * 1000;

                        BigDecimal b11 = new BigDecimal(xa);
                        xa = b11.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b22 = new BigDecimal(xb);
                        xb = b22.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b33 = new BigDecimal(xc);
                        xc = b33.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b4 = new BigDecimal(xp1);
                        xp1 = b4.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();
                        BigDecimal b5 = new BigDecimal(xp2);
                        xp2 = b5.setScale(5, BigDecimal.ROUND_HALF_UP).doubleValue();


                        ZConsumption zConsumption = new ZConsumption();
                        zConsumption.setGlueAMaterial(xa);
                        zConsumption.setGlueBMaterial(xb);
                        zConsumption.setAntiStarchMaterial(xc);
                        zConsumption.setTphosphors0(xp1);
                        zConsumption.setTphosphors1(xp2);
                        zConsumptions.add(zConsumption);
                    }

                    tt.setZConsumptions(zConsumptions);

                }
            }

            return ResultUtils.success(tModelFormulas);

/*
        }
        return ResultUtils.error(1,"请确认配比");
*/
    }

    /**
     * 从配比库中获取配比
     * @return
     */
     public TAIModelDtl getRatioFromModelFormula(Long modelId){
         TAIModelDtl taiModelDtl = this.tAiModelMapper.getOneMoldeByModelId(modelId);//获取生产搭配详情

         List<TBom> tBomList = this.tAiModelMapper.findBomByModelId(taiModelDtl.getId());//获取bom信息
         List<TModelFormula> tModelFormulas = this.tAiModelMapper.findTModelFormula(modelId);//从配比库中获取配比信息
         List<TColorRegionDtl> colorRegionDtls= this.tAiModelMapper.outputRequiremendtlsByOutRequireId(taiModelDtl.getOutputRequireMachineId());//色区详情
         taiModelDtl.setBomList(tBomList);
         taiModelDtl.setTModelFormulas(tModelFormulas);
         taiModelDtl.setColorRegionDtls(colorRegionDtls);
         return taiModelDtl;

     }

    /**
     * 从材料表获取配比信息
     *
     * @param modelId
     * @return
     */
    public TAIModelDtl getRatioFromMaterialTable(Long modelId) {
        TAIModelDtl taiModelDtl = this.tAiModelMapper.getOneMoldeByModelId(modelId);//获取生产搭配详情

        List<TBom> tBomList = this.tAiModelMapper.findBomByModelId(taiModelDtl.getId());//获取bom信息
        //List<TModelFormula> tModelFormulas = this.tAiModelMapper.findTModelFormula(taiModelDtl.getId());//从配比库中获取配比信息
        List<Map<String, Object>> modelWithBomList = tAiModelMapper.findModelWithBom(modelId);//模型和其对应的BOM关系

        int index = 0;
        List<TModelFormula> tModelFormulaList = modelWithBomList.stream().map(temp -> {
            TModelFormula tModelFormula = new TModelFormula();
            Long bomId = (Long) temp.get("bomId");
            tModelFormula.setBomId(bomId);
            tModelFormula.setModelBomId((Long) temp.get("modelBomId"));
            tModelFormula.setModelId(modelId);
            //A 胶
            TMaterialFormula gluATModelFormula = this.tAiModelMapper.findMaterialGlueARatioByBomId(bomId);
            tModelFormula.setGlueAMaterial(gluATModelFormula);

            //B胶
            TMaterialFormula gluBTModelFormula = this.tAiModelMapper.findMaterialGlueBRatioByBomId(bomId);
            tModelFormula.setGlueBMaterial(gluBTModelFormula);

            //抗沉淀粉
            TMaterialFormula antiStarchTModelFormula = this.tAiModelMapper.findMaterialAntiStarchRaitoByBomId(bomId);
            tModelFormula.setAntiStarchMaterial(antiStarchTModelFormula);

            //扩散粉
            TMaterialFormula diffusionPowder = this.tAiModelMapper.findMaterialDiffusionPowderRaitoByBomId(bomId);
            tModelFormula.setDiffusionPowderMaterial(diffusionPowder);

            //荧光粉获取 - 因为没有所以荧光粉是null
          /*  TBom tBom = tBomList.stream().filter(o -> Objects.equals(o.getId(), bomId)).findFirst().orElse(null);
            List<TPhosphor> tPhosphorList = tBom.getTPhosphors();

            List<TMaterialFormula> tPhosphorWithRatioList = tPhosphorList.stream().map(t -> {
                TMaterialFormula tMaterialFormula = new TMaterialFormula();
                tMaterialFormula.setMaterialId(t.getId());
                tMaterialFormula.setRatio(null);
                tMaterialFormula.setSpec(tMaterialFormula.getSpec());
                return tMaterialFormula;
            }).collect(toList());

            tModelFormula.setTPhosphors(tPhosphorWithRatioList);*/
            tModelFormula.setTPhosphors(new ArrayList<>());//没有直接返回空数组
            return tModelFormula;

        }).collect(toList());


        List<TColorRegionDtl> colorRegionDtls = this.tAiModelMapper.outputRequiremendtlsByOutRequireId(taiModelDtl.getOutputRequireMachineId());//色区详情
        taiModelDtl.setBomList(tBomList);
        taiModelDtl.setTModelFormulas(tModelFormulaList);
        taiModelDtl.setColorRegionDtls(colorRegionDtls);
        return taiModelDtl;
    }



    /**
     * 通过模型获取配比库
     *  配比库中有就从配比库中获取 -> 里获取配比信息
     *         没有就从材料库中获取基础配置
     * @param modelId
     * @return
     */
    public Result<TAIModelDtl> getOneMoldeByModelId(Long modelId){
        TAIModelDtl taiModelDtl = this.tAiModelMapper.getOneMoldeByModelId(modelId);
       /* //是否有坑沉淀粉
        Boolean isAntiStarch = false;*/
        if(taiModelDtl!=null){
            List<TBom> tBomList = this.tAiModelMapper.findBomByModelId(taiModelDtl.getId());
            Integer isRatio =  tAiModelMapper.findExitFormulaByModelId(modelId);//配比库中是否有配比
            //获取这个配方在配比库中的配比
            List<TModelFormula> tModelFormulas = this.tAiModelMapper.findTModelFormula(taiModelDtl.getId());

            //如果没有配比则取材料库中的配比
            if( Objects.equals(isRatio,0) ){
                for (TModelFormula t2:
                        tModelFormulas) {
                        //A 胶
                        TMaterialFormula gluATModelFormula = this.tAiModelMapper.findMaterialGlueARatioByBomId(t2.getBomId());
                        t2.setGlueAMaterial(gluATModelFormula);

                        //B胶
                        TMaterialFormula gluBTModelFormula = this.tAiModelMapper.findMaterialGlueBRatioByBomId(t2.getBomId());
                        t2.setGlueBMaterial(gluBTModelFormula);

                        //抗沉淀粉
                        TMaterialFormula antiStarchTModelFormula = this.tAiModelMapper.findMaterialAntiStarchRaitoByBomId(t2.getBomId());
                        t2.setAntiStarchMaterial(antiStarchTModelFormula);

                        //扩散粉
                        TMaterialFormula diffusionPowder = this.tAiModelMapper.findMaterialDiffusionPowderRaitoByBomId(t2.getBomId());
                        t2.setDiffusionPowderMaterial(diffusionPowder);

                        /* //如果坑沉点粉
                        if(t2.getAntiStarchMaterial() != null){
                            t2.setDiffusionPowderMaterial(null);
                        }*/
                }
            }




           /* for (TModelFormula t2:
                    tModelFormulas) {
                if(null == t2.getGlueAMaterial()){
                    TMaterialFormula gluATModelFormula = this.tAiModelMapper.findMaterialGlueARatioByBomId(t2.getBomId());
                    t2.setGlueAMaterial(gluATModelFormula);
                }
                if(null == t2.getGlueBMaterial()){
                    TMaterialFormula gluBTModelFormula = this.tAiModelMapper.findMaterialGlueBRatioByBomId(t2.getBomId());
                    t2.setGlueBMaterial(gluBTModelFormula);
                }
                if(null == t2.getAntiStarchMaterial()){
                    TMaterialFormula antiStarchTModelFormula = this.tAiModelMapper.findMaterialAntiStarchRaitoByBomId(t2.getBomId());
                    t2.setAntiStarchMaterial(antiStarchTModelFormula);
                }
                if(null == t2.getDiffusionPowderMaterial()){
                    TMaterialFormula diffusionPowder = this.tAiModelMapper.findMaterialDiffusionPowderRaitoByBomId(t2.getBomId());
                    t2.setDiffusionPowderMaterial(diffusionPowder);
                }
               *//* //如果坑沉点粉
                if(t2.getAntiStarchMaterial() != null){
                    t2.setDiffusionPowderMaterial(null);
                }*//*
            }*/
            List<TColorRegionDtl> colorRegionDtls= this.tAiModelMapper.outputRequiremendtlsByOutRequireId(taiModelDtl.getOutputRequireMachineId());
            taiModelDtl.setBomList(tBomList);
            taiModelDtl.setTModelFormulas(tModelFormulas);
            taiModelDtl.setColorRegionDtls(colorRegionDtls);
            return ResultUtils.success(taiModelDtl);
        }
        return ResultUtils.error(1,"通过模型ID未获取对应的配方信息");
    }







    /**
     * 新建配比按钮
     * @param editTaskFormulaForPage
     */
    @Transactional
    @Override
    public Result addTaskFormulaForPage(EditTaskFormulaForPage editTaskFormulaForPage){
        log.info("当前方法的为  {新建配比按钮}   {addTaskFormulaForPage}");
        log.info("当前的工单taskId：{}", editTaskFormulaForPage.getTaskId());
        log.info("当前的工单状态taskStateId：{}", editTaskFormulaForPage.getTaskStateId());


        EditTModelFormulaForPage editTModelFormulaForPage = new EditTModelFormulaForPage();
        List<TModelFormulaForTables> tModelFormulaForTables = editTaskFormulaForPage.getTModelFormulaForTables();
        BsFormulaUpdateLog bsFormulaUpdateLog = editTaskFormulaForPage.getBsFormulaUpdateLog();
        bsFormulaUpdateLog.setUpdateType(FormulaUpdateClassEnum.UserEdit.getStateFlag());
        editTModelFormulaForPage.setBsFormulaUpdateLog(bsFormulaUpdateLog);
        editTModelFormulaForPage.setTModelFormulaForTables(tModelFormulaForTables);
        //配比库中新增配比
        tAiModelService.addModelFormula(editTModelFormulaForPage);
        //工单中新建对应的配比
        addTaskFormula(editTaskFormulaForPage);
        log.info("当前方法的为  {新建配比按钮}   {editTaskFormulaForPage} ==== end");
        return ResultUtils.success();
    }



    /**
     * 新增工单状态配比表
     * @param editTaskFormulaForPage
     */
    @Transactional
    public  void addTaskFormula(EditTaskFormulaForPage editTaskFormulaForPage){
        List<TModelFormulaForTables> tModelFormulaForTables = editTaskFormulaForPage.getTModelFormulaForTables();

        Long  modelBomId = tModelFormulaForTables.get(0).getModelBomId();
        TModelBom tModelBom = this.tAiModelMapper.findModeBomByModelBomId(modelBomId);
        Long bomId = tModelBom.getBomId();

        Long taskStateId = editTaskFormulaForPage.getTaskStateId();
        //维护配比信息
        bsTaskStateDao.updateTaskRatioInfo(taskStateId,0,editTaskFormulaForPage.getBsFormulaUpdateLog().getCreator(),RatioSourceEnum.USER_EDIT.getFlag());

        //工单BOM数据
        BsTaskFormula bsTaskFormula = new BsTaskFormula();
        bsTaskFormula.setTaskBomId(bomId);
        bsTaskFormula.setTaskStateId(editTaskFormulaForPage.getTaskStateId());

        //新增task_bom表
        bsTaskFormulaDao.insertSelective(bsTaskFormula);

        //BOM对应的配比详情
        List<BsTaskFormulaDtl> bsTaskFormulaDtlist = new ArrayList<>();

        for (TModelFormulaForTables t:
        tModelFormulaForTables) {
            BsTaskFormulaDtl bsTaskFormulaDtl = new BsTaskFormulaDtl();
            bsTaskFormulaDtl.setMaterialClass(t.getMaterialClass());
            bsTaskFormulaDtl.setMaterialId(t.getMaterialId());
            bsTaskFormulaDtl.setRatio(t.getRatio());
            bsTaskFormulaDtl.setTaskFormulaId(bsTaskFormula.getId());
            bsTaskFormulaDtlist.add(bsTaskFormulaDtl);
        }

        bsTaskFormulaDtlDao.batchInsert(bsTaskFormulaDtlist);
    }


    /**
     * 配比编辑按钮
     * 1.如果是试样判断新增或修改
     * 2.如果不是试样
     * 3.新增状态
     * 4.删除阀体工单热表
     * @param bsTaskFormulaForPage
     */
    @Override
    @Transactional
    public Result taskFormulaEdit(BsTaskFormulaForPage bsTaskFormulaForPage)throws QuException{
        log.info("当前方法的为  {配比编辑按钮}   {taskFormulaEdit}");
        log.info("当前的工单taskId：{}", bsTaskFormulaForPage.getTaskId());
        log.info("当前的工单状态taskStateId：{}", bsTaskFormulaForPage.getTaskStateId());

        //Long olderTaskStateId = null;
        Long currentTaskStateId = bsTaskFormulaForPage.getTaskStateId();
        Long newTaskStateId = null;
        Long userId = bsTaskFormulaForPage.getUserId();

        Long taskId = bsTaskFormulaForPage.getTaskId();
        //获取当前的工单状态数据
        //BsTaskState bsTaskState = this.bsTaskStateDao.getActiveTaskStateAllInfo(taskId);
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(bsTaskFormulaForPage.getTaskStateId());
        Long oldTaskDfId = taskStateForDatabase.getTaskDfId();
        log.info("当前的工单状态：{}", TaskEnum.stateFlagOf(taskStateForDatabase.getTaskDfId()).getStateName());


       // olderTaskStateId = bsTaskState.getId();
        //工单状态定义id
        //Long taskDfId = bsTaskState.getTaskDfId();


       /* if(bsTaskFormulaList != null && bsTaskFormulaList.size() > 0){
            //原先的配比
            List<BsTaskFormulaDtl> oldBsTaskFormulaDtlList = this.bsTaskFormulaDao.getBsTaskFormulaDtl(bsTaskFormulaList.get(0).getId());

        }*/

        System.out.println("前端页面获取的配比======>" + bsTaskFormulaForPage);


        //当前的配比
        List<BsTaskFormula> bsTaskFormulaList =  this.bsTaskFormulaDao.getTaskFormulaForTaskState(currentTaskStateId);
        //bsTaskFormulaList.forEach(System.out::println);


        //如果当前状态无配比则新增当前配比 且配比版本为0，如果有配比则 新增一条工单状态，不论当前工单状态是否时待生产
        if(bsTaskFormulaList.size() == 0){
            addTaskFormula(bsTaskFormulaForPage);
            bsTaskStateDao.updateTaskRatioInfo(currentTaskStateId,0,userId, RatioSourceEnum.USER_EDIT.getFlag());
        }else {
            //把旧的数据转换为不活跃状态
            bsTaskStateDao.updateTaskStateToNotActive(currentTaskStateId);
            //新增数据
            taskStateForDatabase.setIsActive(1);
            taskStateForDatabase.setRatioCreateTime(Convert.getNow());
            taskStateForDatabase.setRatioCreator(userId);
            taskStateForDatabase.setRatioSource(RatioSourceEnum.USER_EDIT.getFlag());
            taskStateForDatabase.setRatioVersion( taskStateForDatabase.getRatioVersion() + 1);
            taskStateForDatabase.setTaskDfId(TaskEnum.TaskPendingSample.getStateFlag());
            taskStateForDatabase.setFileidList("");//工单状态对应的分光文件清空
            bsTaskStateDao.addTaskState(taskStateForDatabase);
            newTaskStateId = taskStateForDatabase.getId();
            //新增配比 -->对应新的工单状态
            bsTaskFormulaForPage.setTaskStateId(newTaskStateId);
            addTaskFormula(bsTaskFormulaForPage);
            //关于阀体继承的判断 如果修改前是量产则不继承，如果修改前不是量产则继承
            if(taskStateForDatabase.getTaskDfId().equals(TaskEnum.TaskBatchProductionValveNG.getStateFlag()) || taskStateForDatabase.getTaskDfId().equals(TaskEnum.TaskBatchProduction.getStateFlag())){
                return ResultUtils.success();
            }

            if(!oldTaskDfId.equals(TaskEnum.TaskBatchProduction.getStateFlag()) && !oldTaskDfId.equals(TaskEnum.TaskBatchProductionValveNG.getStateFlag())){
                //复制阀体
                taskEeqptValveCopy(currentTaskStateId,newTaskStateId,EqptValveStateEnum.NOProduction.getStateFlag());
                //复制阀体对应的点胶设定参数
                copyTaskEqptGlueDosage(currentTaskStateId,newTaskStateId);
            }

        }

        //如果是待生产阶段并且当前状态无配比则新增，有则修改，工单状态不变
      /*  if( taskStateForDatabase.getTaskDfId().equals( TaskEnum.TaskPendingSample.getStateFlag() ) ){
            if( bsTaskFormulaList.size() == 0 ){
                addTaskFormula(bsTaskFormulaForPage);
                return ResultUtils.success();
            }else{
                updateTaskFormula(bsTaskFormulaForPage);
                return ResultUtils.success();
            }

        }else{

            //2.修改之前的状态
            bsTaskState.setCheckUser(userId);
            bsTaskState.setUpdateUser(userId);
            bsTaskState.setIsActive(false);
            bsTaskState.setSolutionType((byte)3);
            this.bsTaskStateDao.updateBsTaskStatesById(bsTaskState);

            //1.新增工单状态数据
            bsTaskState.setIsActive(true);
            bsTaskState.setCreator(userId);
            bsTaskState.setTaskDfId(TaskEnum.TaskPendingSample.getStateFlag());
            Integer num = 0;
            num = this.bsTaskStateDao.insertSelectiveNoWithFileIdList(bsTaskState);
            if( num == 0 ){
                throw  new QuException(1,"重复调用");
            }
            newTaskStateId = bsTaskState.getId();

            //4.删除阀体工单热表
            this.bsTaskStateDao.deleteBsEqptTaskRuntimeByTaskId(taskId);

            //新增配比 -->对应新的工单状态
            bsTaskFormulaForPage.setTaskStateId(newTaskStateId);
            addTaskFormula(bsTaskFormulaForPage);
        }*/
        return ResultUtils.success();
    }



    /**
     * 使用推荐配比按钮
     * 1.如果是试样判断新增或修改
     * 2.如果不是试样
     * 3.新增状态
     * 4.删除阀体工单热表
     * @param bsTaskFormulaForPage
     */
    @Override
    @Transactional
    public Result updateUseAdviceFormulaEdit(BsTaskFormulaForPage bsTaskFormulaForPage)throws QuException{
        log.info("当前方法的为  {使用推荐配比按钮}   {updateUseAdviceFormulaEdit}");
        log.info("当前的工单taskId：{}", bsTaskFormulaForPage.getTaskId());
        log.info("当前的工单状态taskStateId：{}", bsTaskFormulaForPage.getTaskStateId());

        //Long olderTaskStateId = null;
        Long currentTaskStateId = bsTaskFormulaForPage.getTaskStateId();
        Long newTaskStateId = null;
        Long userId = bsTaskFormulaForPage.getUserId();

        Long taskId = bsTaskFormulaForPage.getTaskId();
        //获取当前的工单状态数据
        //BsTaskState bsTaskState = this.bsTaskStateDao.getActiveTaskStateAllInfo(taskId);
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(bsTaskFormulaForPage.getTaskStateId());
        Long oldTaskDfId = taskStateForDatabase.getTaskDfId();
        log.info("当前的工单状态：{}", TaskEnum.stateFlagOf(taskStateForDatabase.getTaskDfId()).getStateName());


        // olderTaskStateId = bsTaskState.getId();
        //工单状态定义id
        //Long taskDfId = bsTaskState.getTaskDfId();


       /* if(bsTaskFormulaList != null && bsTaskFormulaList.size() > 0){
            //原先的配比
            List<BsTaskFormulaDtl> oldBsTaskFormulaDtlList = this.bsTaskFormulaDao.getBsTaskFormulaDtl(bsTaskFormulaList.get(0).getId());

        }*/

        System.out.println("前端页面获取的配比======>" + bsTaskFormulaForPage);


        //当前的配比
        List<BsTaskFormula> bsTaskFormulaList =  this.bsTaskFormulaDao.getTaskFormulaForTaskState(currentTaskStateId);
        //bsTaskFormulaList.forEach(System.out::println);


        //如果当前状态无配比则新增当前配比 且配比版本为0，如果有配比则 新增一条工单状态，不论当前工单状态是否时待生产
        if(bsTaskFormulaList.size() == 0){
            addTaskFormula(bsTaskFormulaForPage);
            bsTaskStateDao.updateTaskRatioInfo(currentTaskStateId,0,userId, RatioSourceEnum.SOME_RECOMMEND.getFlag());
        }else {
            //把旧的数据转换为不活跃状态
            bsTaskStateDao.updateTaskStateToNotActive(currentTaskStateId);
            //新增数据
            taskStateForDatabase.setIsActive(1);
            taskStateForDatabase.setRatioCreateTime(Convert.getNow());
            taskStateForDatabase.setRatioCreator(userId);
            taskStateForDatabase.setRatioSource(RatioSourceEnum.SOME_RECOMMEND.getFlag());
            taskStateForDatabase.setRatioVersion( taskStateForDatabase.getRatioVersion() + 1);
            taskStateForDatabase.setTaskDfId(TaskEnum.TaskPendingSample.getStateFlag());
            taskStateForDatabase.setFileidList("");//工单状态对应的分光文件清空
            bsTaskStateDao.addTaskState(taskStateForDatabase);
            newTaskStateId = taskStateForDatabase.getId();
            //新增配比 -->对应新的工单状态
            bsTaskFormulaForPage.setTaskStateId(newTaskStateId);
            addTaskFormula(bsTaskFormulaForPage);
            //关于阀体继承的判断 如果修改前是量产则不继承，如果修改前不是量产则继承
            if(taskStateForDatabase.getTaskDfId().equals(TaskEnum.TaskBatchProductionValveNG.getStateFlag()) || taskStateForDatabase.getTaskDfId().equals(TaskEnum.TaskBatchProduction.getStateFlag())){
                return ResultUtils.success();
            }

            if(!oldTaskDfId.equals(TaskEnum.TaskBatchProduction.getStateFlag()) && !oldTaskDfId.equals(TaskEnum.TaskBatchProductionValveNG.getStateFlag())){
                //复制阀体
                taskEeqptValveCopy(currentTaskStateId,newTaskStateId,EqptValveStateEnum.NOProduction.getStateFlag());
                //复制阀体对应的点胶设定参数
                copyTaskEqptGlueDosage(currentTaskStateId,newTaskStateId);
            }

        }

        //如果是待生产阶段并且当前状态无配比则新增，有则修改，工单状态不变
      /*  if( taskStateForDatabase.getTaskDfId().equals( TaskEnum.TaskPendingSample.getStateFlag() ) ){
            if( bsTaskFormulaList.size() == 0 ){
                addTaskFormula(bsTaskFormulaForPage);
                return ResultUtils.success();
            }else{
                updateTaskFormula(bsTaskFormulaForPage);
                return ResultUtils.success();
            }

        }else{

            //2.修改之前的状态
            bsTaskState.setCheckUser(userId);
            bsTaskState.setUpdateUser(userId);
            bsTaskState.setIsActive(false);
            bsTaskState.setSolutionType((byte)3);
            this.bsTaskStateDao.updateBsTaskStatesById(bsTaskState);

            //1.新增工单状态数据
            bsTaskState.setIsActive(true);
            bsTaskState.setCreator(userId);
            bsTaskState.setTaskDfId(TaskEnum.TaskPendingSample.getStateFlag());
            Integer num = 0;
            num = this.bsTaskStateDao.insertSelectiveNoWithFileIdList(bsTaskState);
            if( num == 0 ){
                throw  new QuException(1,"重复调用");
            }
            newTaskStateId = bsTaskState.getId();

            //4.删除阀体工单热表
            this.bsTaskStateDao.deleteBsEqptTaskRuntimeByTaskId(taskId);

            //新增配比 -->对应新的工单状态
            bsTaskFormulaForPage.setTaskStateId(newTaskStateId);
            addTaskFormula(bsTaskFormulaForPage);
        }*/
        return ResultUtils.success();
    }



    /**此时页面显示的是编辑按钮
     * 工单状态配比新增对应工单状态有配比的情况
     * 修改工单配比信息
     */
    @Transactional
    public void updateTaskFormula(BsTaskFormulaForPage bsTaskFormulaForPage){
        Long bomId = bsTaskFormulaForPage.getBomId();
        Long taskStateId = bsTaskFormulaForPage.getTaskStateId();
        BsTaskFormula bsTaskFormula = bsTaskFormulaDao.getTaskFormula(taskStateId,bomId);
        List<BsTaskFormulaDtl> bsTaskFormulaDtlList =  bsTaskFormulaForPage.getBsTaskFormulaDtlList();
        //删除前面的配比详情
        bsTaskFormulaDao.deleteBsTaskFormulaDtlBytaskFormulaId(bsTaskFormula.getId());
        for (BsTaskFormulaDtl t:
                bsTaskFormulaDtlList) {
            t.setTaskFormulaId(bsTaskFormula.getId());
        }
        //新增配比详情表
        bsTaskFormulaDtlDao.batchInsert(bsTaskFormulaDtlList);
    }


    /**此时页面显示的是编辑按钮
     * 工单状态配比新增对应生产搭配有配比但该状态下工单无配比的情况
     * 此工单无配比的情况
     */
    @Transactional
    public void addTaskFormula(BsTaskFormulaForPage bsTaskFormulaForPage)throws QuException{
        //bomID
        Long bomId = bsTaskFormulaForPage.getBomId();
        Long taskStateId = bsTaskFormulaForPage.getTaskStateId();
        if(null != bomId){
             new QuException(1,"新增时配比时bomId为空");
        }
        if(null != taskStateId){
            new QuException(1,"新增配比时工单状态IDtaskStateId为空");
        }
        BsTaskFormula bsTaskFormula = new BsTaskFormula();
        bsTaskFormula.setTaskStateId(taskStateId);
        bsTaskFormula.setTaskBomId(bomId);
        //新增工单状态配比中间表
        bsTaskFormulaDao.insertSelective(bsTaskFormula);
        List<BsTaskFormulaDtl> bsTaskFormulaDtlList =  bsTaskFormulaForPage.getBsTaskFormulaDtlList();

        for (BsTaskFormulaDtl t:
                bsTaskFormulaDtlList) {
            t.setTaskFormulaId(bsTaskFormula.getId());
        }
        //新增配比详情表
        bsTaskFormulaDtlDao.batchInsert(bsTaskFormulaDtlList);
    }



    /**
     * 获取可供选择的阀体
     * @param positon
     * @return
     */
    @Override
    public Result  getListOfOptionsEqptValve(Integer positon){
        List<TEqpt> list = this.bsTaskStateDao.getListOfOptionsEqptValve(positon);
        for (TEqpt t:
            list) {
            List<TEqptValve> tEqptValveList =  this.bsTaskStateDao.findTeqptValveList(t.getId());
            t.setTEqptValveList(tEqptValveList);
        }
        return ResultUtils.success(list);
    }



    /**
     * 工单关闭操作
     * 首先获取当前工单的状态数据
     * 1.新增工单状态表，修改工单状态表原来的数据
     * 2.工单关闭 设置为关闭 ，更新关闭时间bs_task
     * 3.复制阀体把阀体状体状态改为已关闭 bs_eqpt_valve_state
     * 4.删除阀体工单对应表里面的数据和此工单对应的数据bs_eqpt_task_runtime
     * 5.工单状态对阀体表设为已关闭
     *
     */
    @Override
    @Transactional
    public Result closeTask(Long taskStateId,Long userId) throws QuException{
        log.info("当前方法的为  {工单关闭操作}   {closeTask}");
        //log.info("当前的工单taskId：{}", taskId);

        Long olderTaskStateId = null;
        Long newTaskStateId = null;
        //获取当前的工单状态数据
        //BsTaskState bsTaskState = this.bsTaskStateDao.getActiveTaskStateAllInfo(taskId);
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);
        log.info("当前的工单状态taskStateId：{}", taskStateId);
        log.info("当前的工单状态：{}", TaskEnum.stateFlagOf(taskStateForDatabase.getTaskDfId()).getStateName());
        olderTaskStateId = taskStateId;



      /*  bsTaskState.setCheckUser(userId);
        bsTaskState.setUpdateUser(userId);
        bsTaskState.setIsActive(false);
        //修改之前的状态
        this.bsTaskStateDao.updateBsTaskStatesById(bsTaskState);
        bsTaskState.setIsActive(true);
        bsTaskState.setCreator(userId);
        bsTaskState.setTaskDfId(TaskEnum.TASKCLOSE.getStateFlag());*/
        bsTaskStateDao.updateTaskStateToNotActive(olderTaskStateId);



        Integer num = 0;
        //新增工单数据
        //num = this.bsTaskStateDao.insertSelectiveNoWithFileIdList(bsTaskState);
        taskStateForDatabase.setIsActive(1);//活跃状态
        taskStateForDatabase.setFileidList("");//为空
        taskStateForDatabase.setTaskDfId(TaskEnum.TASKCLOSE.getStateFlag());
        num = bsTaskStateDao.addTaskState(taskStateForDatabase);

        if(num == 0){
            throw  new QuException(1,"重复调用");
        }
        //newTaskStateId = bsTaskState.getId();
        newTaskStateId = taskStateForDatabase.getId();
        //删除工单对阀体的热表
        this.bsTaskStateDao.deleteBsEqptTaskRuntimeByTaskId(taskStateForDatabase.getTaskId());
        //复制未关闭阀体并且把阀体设置为已关闭
        taskEeqptValveCopy(olderTaskStateId,newTaskStateId, EqptValveStateEnum.CLOSE.getStateFlag());
        //关闭工单
        this.bsTaskStateDao.closeTask(taskStateForDatabase.getTaskId() , userId);
        log.info("当前方法的为  {工单关闭操作}   {closeTask} == end");
        return ResultUtils.success();
    }


    /**
     * 开始试样
     * 1.增加工单状态
     * 2.更新前一个状态的部分数据
     * 3.复制阀体
     * 4.复制配比
     * 5.复制点胶设定参数
     * @param taskStateId
     * @param userId
     */
    @Transactional
    @Override
    public Result beginSY(Long taskStateId, Long userId){
        log.info("当前方法的为  {开始试样}   {beginSY}");
        //log.info("当前的工单taskId：{}", taskId);
        //Long olderTaskStateId = null;
        Long currentTaskStateId = taskStateId;
        Long newTaskStateId = null;
        //获取当前的工单状态数据
        //BsTaskState bsTaskState = this.bsTaskStateDao.getActiveTaskStateAllInfo(taskId);
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);
        Long modelId = taskStateForDatabase.getModelId();
        log.info("当前的工单状态taskStateId：{}", taskStateId);
        log.info("当前的工单状态：{}", TaskEnum.stateFlagOf(taskStateForDatabase.getTaskDfId()).getStateName());
        //olderTaskStateId = bsTaskState.getId();
     /*   bsTaskState.setCheckUser(userId);
        bsTaskState.setUpdateUser(userId);
        bsTaskState.setIsActive(false);
        //2.修改之前的状态
        this.bsTaskStateDao.updateBsTaskStatesById(bsTaskState);

        bsTaskState.setIsActive(true);
        bsTaskState.setCreator(userId);
        bsTaskState.setTaskDfId(TaskEnum.TaskSamplePreTest.getStateFlag());*/
        //修改之前的工单状态
        bsTaskStateDao.updateTaskStateToNotActive(currentTaskStateId);
        taskStateForDatabase.setTaskDfId(TaskEnum.TaskSamplePreTest.getStateFlag());



        Integer num1 = 0;
        //1.新增工单数据
        //num1 = this.bsTaskStateDao.insertSelectiveNoWithFileIdList(bsTaskState);
        num1 = bsTaskStateDao.addTaskState(taskStateForDatabase);
       /* if(num1 == 0){
            new QuException(1,"重复调用");
        }*/
        //newTaskStateId = bsTaskState.getId();
        newTaskStateId = taskStateForDatabase.getId();
        //3.复制未关闭阀体并且把阀体设置为生产中
        taskEeqptValveCopy(currentTaskStateId,newTaskStateId, EqptValveStateEnum.INProduction.getStateFlag());
        //5.复制点胶设定参数
        copyTaskEqptGlueDosage(currentTaskStateId,newTaskStateId);
       /* //6.是否需要新增配比
        Integer num = this.bsTaskFormulaDao.isTaskformula(currentTaskStateId);
        if(num == 0){
            log.info("当前方法的为  {开始试样}   {beginSY} === end");
           return beginSYJudgeFormula(currentTaskStateId,newTaskStateId);
        }else{

        }*/
        //4.复制配比
        taskFormulaCopy(currentTaskStateId,newTaskStateId);
        log.info("当前方法的为  {开始试样}   {beginSY} === end");
        return ResultUtils.success();
    }


    /**
     * 开始试样判断配比是否存在不存在就从配比库中复制配比
     * @return
     */
    @Transactional
   public Result beginSYJudgeFormula(Long olderTaskStateId,Long newTaskStateId){
       List<BsTaskFormulaMix> bsTaskFormulaList =
               bsTaskFormulaDao.getTaskFormulaForTaskStateFromAiModel(olderTaskStateId);
       List<BsTaskFormulaDtl> bsTaskFormulaDtlList = new ArrayList<>();
        for (BsTaskFormulaMix t:
                bsTaskFormulaList) {
            BsTaskFormula bsTaskFormula = new BsTaskFormula();
            bsTaskFormula.setTaskBomId(t.getTaskBomId());
            bsTaskFormula.setTaskStateId(newTaskStateId);
            this.bsTaskFormulaDao.insertSelective(bsTaskFormula);

            for (BsTaskFormulaDtl t2:
                    t.getBsTaskFormulaDtlList()) {
                t2.setTaskFormulaId(bsTaskFormula.getId());
                bsTaskFormulaDtlList.add(t2);
            }
        }
       this.bsTaskFormulaDtlDao.batchInsert(bsTaskFormulaDtlList);
        return  ResultUtils.success();
    }



    /**
     * 判定NG 对具体的阀体进行NG判定
     * 1.新增状态
     * 2.修改前面状态数据
     * 3.复制阀体
     * 4.复制点胶设定参数
     * 5.复制配比
     * 6.修改阀体状态
     * @param taskId 工单ID
     * @param eqptValveId 阀体ID
     * @param userId 用户ID
     * @param judgementResult 判定结果，按照色坐标，亮度，Ra,R9的顺序传
     *                        0 :0k 1:NG,中间用逗号分隔
     *
     *
     *
     */
    @Transactional
    @Override
    public Result setNG(Long taskStateId, Long eqptValveId, Long userId,String judgementResult ){
        log.info("当前方法的为  {判定NG}   {setNG}");
        //log.info("当前的工单taskId：{}", taskId);
        log.info("当前的工单阀体ID->eqptValveId：{}", eqptValveId);
        log.info("当前的用户ID->eqptValveId：{}", userId);
        Long newTaskDfId = null;
        Long olderTaskStateId = null;
        Long newTaskStateId = null;

        //获取当前的工单状态数据
        //BsTaskState bsTaskState = this.bsTaskStateDao.getActiveTaskStateAllInfoWithFileIdList(taskId);
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);

        //olderTaskStateId = taskStateId;
        log.info("当前的工单状态taskStateId：{}", taskStateId);
        log.info("当前的工单状态：{}", TaskEnum.stateFlagOf(taskStateForDatabase.getTaskDfId()).getStateName());
        String fileList = taskStateForDatabase.getFileidList();
        //工单状态定义id
        Long taskDfId = taskStateForDatabase.getTaskDfId();


        //记录每个文件的个参数的判定结果
        recordJudgementResult(fileList,eqptValveId,judgementResult);

        //如果所有的都是ok的则走ok接口
      /*  if(!judgementResult.contains("1")){
            return testOk(taskStateId,eqptValveId,userId);
        }*/
        //1ng,2偏高，3偏低
        if(!judgementResult.contains("1") && !judgementResult.contains("2") && !judgementResult.contains("3")){
            return testOk(taskStateId,eqptValveId,userId);
        }

        //试样前测中
        if(taskDfId.equals(TaskEnum.TaskSamplePreTest.getStateFlag())){
            newTaskDfId = TaskEnum.TaskSamplePreTestNG.getStateFlag();

        }

        //试样前测通过
        else if(taskDfId.equals(TaskEnum.TaskSamplePreTestOK.getStateFlag())){
            newTaskDfId = TaskEnum.TaskSampleQualityTestNG.getStateFlag();

        }
        //批量生产
        else if(taskDfId.equals(TaskEnum.TaskBatchProduction.getStateFlag())){
            newTaskDfId = TaskEnum.TaskBatchProductionValveNG.getStateFlag();
        }
        //批量生产阀体NG
        else if(taskDfId.equals(TaskEnum.TaskBatchProductionValveNG.getStateFlag())){
            //7.修改文件状态为NG
            this.bsTaskStateDao.updateFileNoJudgeToNg(fileList,eqptValveId,userId);
            //6.修改当前阀体的状态为NG
            olderTaskStateId = taskStateId;
            this.bsTaskStateDao.updateOneBsEqptValveStateByTaskId(EqptValveStateEnum.ProductionNG.getStateFlag(),olderTaskStateId,eqptValveId);
            log.info("当前方法的为  {判定NG}   {setNG} === end");
            return ResultUtils.success();
        }else{
            String errStr = "状态异常,无法NG";
            log.info("当前方法的为  {判定NG}   {setNG} === end");
            return ResultUtils.error(1,errStr);
        }

      /*  //工单状态ID
        olderTaskStateId = bsTaskState.getId();
        bsTaskState.setCheckUser(userId);
        bsTaskState.setUpdateUser(userId);
        bsTaskState.setIsActive(false);
        //2.修改之前的状态
        this.bsTaskStateDao.updateBsTaskStatesById(bsTaskState);
        //1.新增状态
        bsTaskState.setIsActive(true);
        bsTaskState.setCreator(userId);
        bsTaskState.setTaskDfId(newTaskDfId);
        Integer num = 0;
        num = this.bsTaskStateDao.insetSelectiveWithOlderFileIdList(bsTaskState);
        if(num == 0){
            throw new QuException(1,"重复调用");
        }
        newTaskStateId = bsTaskState.getId();*/

        olderTaskStateId = taskStateId;
        bsTaskStateDao.updateTaskStateToNotActive(taskStateId);
        taskStateForDatabase.setTaskDfId(newTaskDfId);
        //Integer num = 0;
        this.bsTaskStateDao.addTaskState(taskStateForDatabase);
        newTaskStateId = taskStateForDatabase.getId();

        //3.复制阀体并且修改单个阀体状态为阀体NG
        taskEeqptValveCopy(olderTaskStateId,newTaskStateId,EqptValveStateEnum.ProductionNG.getStateFlag(),eqptValveId);
        //4.复制配比
        taskFormulaCopy(olderTaskStateId,newTaskStateId);
        //5.复制点胶设定参数
        copyTaskEqptGlueDosage(olderTaskStateId,newTaskStateId);
        //6.修改文件状态为NG
        this.bsTaskStateDao.updateFileNoJudgeToNg(fileList,eqptValveId,userId);

        log.info("当前方法的为  {判定NG}   {setNG} === end");
        return ResultUtils.success();
    }
    private final static Integer fileStateNoJudge = -1;//未判定
    private final static Integer fileStateJudgeOK = 0;//判定ok
    private final static Integer fileStateJudgeNg = 1;//判定NG

    /**
     * 取消NG
     * 1.新增状态
     * 2.修改前面状态数据
     * 3.复制阀体
     * 4.复制点胶设定参数
     * 5.复制配比
     * 6.修改阀体状态
     * 7.修改文件状态
     * @param taskId 工单ID
     * @param eqptValveIdList 阀体ID
     * @param userId 用户ID
     */
    @Override
    @Transactional
    public Result cancelNG(Long taskStateId, List<Long> eqptValveIdList, Long userId,Integer raRequire,Integer compulsoryPass,Integer updateChipArea) throws QuException{
        log.info("当前方法的为  {取消NG}   {cancelNG}");
        //log.info("当前的工单taskId：{}", taskId);
        log.info("当前的工单taskStateId：{}", taskStateId);
        log.info("当前的工单取消NG的阀体数量->eqptValveIdList.size()：{}", eqptValveIdList.size());
        log.info("当前的用户ID->userId：{}", userId);


        Long olderTaskStateId = taskStateId;

        Long newTaskDfId = null;
        Long newTaskStateId = null;
        //是否需要复制文件ID
        Boolean isCopyFileList = false;
        //是否需要判断同步配比到配比库中
        Boolean isJudgeSynchronizationFormula = false;
        //更改RaR9要求 0 - 忽略
        /*if(raRequire.equals(0)){
            this.bsTaskStateDao.updateBsTaskRaR9Require(taskStateId,raRequire);
        }*/
        //获取当前的工单状态数据
        //BsTaskState bsTaskState = this.bsTaskStateDao.getActiveTaskStateAllInfoWithFileIdList(taskId);
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);
        //olderTaskStateId = bsTaskState.getId();
        //工单状态定义id
        //Long taskDfId = bsTaskState.getTaskDfId();
        Long taskDfId = taskStateForDatabase.getTaskDfId();
        Integer processType = taskStateForDatabase.getProcessType();
        //log.info("当前的工单状态taskStateId：{}", bsTaskState.getId());
        log.info("当前的工单状态：{}", TaskEnum.stateFlagOf(taskDfId).getStateName());

        //试样前测NG
        if(taskDfId.equals(TaskEnum.TaskSamplePreTestNG.getStateFlag())){
            if(updateChipArea.equals(0)) {
                newTaskDfId = TaskEnum.TaskSamplePreTestOK.getStateFlag();
            }
            if(updateChipArea.equals(1)){
                newTaskDfId = TaskEnum.TaskSamplePreTest.getStateFlag();
            }

        }
        //试样前测通过品质NG
        else if(taskDfId.equals(TaskEnum.TaskSampleQualityTestNG.getStateFlag()) && processType.equals(ProcessTypeEnum.MAIN_PROCESS.getFlag())){
            if(updateChipArea.equals(0)){
                //批量生产阶段
                newTaskDfId = TaskEnum.TaskBatchProduction.getStateFlag();
                isJudgeSynchronizationFormula = true;
            }
            if(updateChipArea.equals(1)){
                newTaskDfId = TaskEnum.TaskSamplePreTestOK.getStateFlag();
            }



        }else if(taskDfId.equals(TaskEnum.TaskSampleQualityTestNG.getStateFlag()) && processType.equals(ProcessTypeEnum.SAMPLE_PROCESS.getFlag())){
            if(updateChipArea.equals(0)){
                newTaskDfId = TaskEnum.TestProcessOK.getStateFlag();
                isJudgeSynchronizationFormula = true;
            }
            if(updateChipArea.equals(1)){
                newTaskDfId = TaskEnum.TaskSamplePreTestOK.getStateFlag();
            }
        }

        //批量生产NG
        else if(taskDfId.equals(TaskEnum.TaskBatchProductionValveNG.getStateFlag())){
            newTaskDfId = TaskEnum.TaskBatchProduction.getStateFlag();

            //NG的阀体数量
            Integer num = bsEqptValveStateDao.getTaskStateNGEqptValveListNum(olderTaskStateId);
            log.info("当前量产阶段工单NG的阀体数量：{}", num);
            log.info("当前量产阶段取消NG的阀体数量：{}", eqptValveIdList.size());
            //如果小于已经NG的阀体数量则只修改文件状态和阀体状态
            if(num > eqptValveIdList.size()){
                //修改阀体为NG状态到生产中
                this.bsTaskStateDao.updateBsEqptValveListStateNGToProduction(EqptValveStateEnum.INProduction.getStateFlag(),olderTaskStateId,eqptValveIdList);
                if(compulsoryPass.equals(0)){
                    //修改判定NG的文件 的JudageType
                    bsTaskStateDao.updateFileJudageTypeWithEqptValveIdList(taskStateForDatabase.getFileidList(),eqptValveIdList,JUDGET_TYPE_N_G_TO_O_K,fileStateJudgeNg);
                }else if(compulsoryPass.equals(1)){
                    //修改判定NG的文件 的JudageType
                    bsTaskStateDao.updateFileJudageTypeWithEqptValveIdList(taskStateForDatabase.getFileidList(),eqptValveIdList,GET_JUDGE_TYPE_FORCE_TO_O_K,fileStateJudgeNg);
                }

                //修改文件状态
                this.bsTaskStateDao.updateUploadFileStateNGToOK(taskStateForDatabase.getFileidList(),eqptValveIdList);
                log.info("当前方法的为  {取消NG}   {cancelNG} === end");
                return ResultUtils.success();
            }
            isCopyFileList = true;
        }else{
            String errStr = "状态异常,无法NG";
            return ResultUtils.error(1,errStr);
        }

        //工单状态ID
       /* olderTaskStateId = bsTaskState.getId();
        bsTaskState.setCheckUser(userId);
        bsTaskState.setUpdateUser(userId);
        bsTaskState.setIsActive(false);
        //2.修改之前的状态
        this.bsTaskStateDao.updateBsTaskStatesById(bsTaskState);
        //1.新增状态
        bsTaskState.setIsActive(true);
        bsTaskState.setCreator(userId);
        bsTaskState.setTaskDfId(newTaskDfId);*/
       bsTaskStateDao.updateTaskStateToNotActive(taskStateId);
       taskStateForDatabase.setTaskDfId(newTaskDfId);
       taskStateForDatabase.setRar9Type(raRequire);//新加
       String fileList = taskStateForDatabase.getFileidList();
        //如果是量产阶段则复制文件ID
        if(isCopyFileList){
          /*  Integer num = 0;
            num = this.bsTaskStateDao.insetSelectiveWithOlderFileIdList(bsTaskState);
            if(num == 0){
                throw  new QuException(1,"重复调用");
            }*/
            bsTaskStateDao.addTaskState(taskStateForDatabase);

        }else {
            /*Integer num = 0;
            num = this.bsTaskStateDao.insertSelectiveNoWithFileIdList(bsTaskState);
            if(num == 0){
                throw  new QuException(1,"");
            }*/
            taskStateForDatabase.setFileidList("");
            bsTaskStateDao.addTaskState(taskStateForDatabase);
        }
        //newTaskStateId = bsTaskState.getId();
        newTaskStateId = taskStateForDatabase.getId();

        //3.复制未关闭的阀体并且把需要取消NG的阀体取消NG
        taskEeqptValveCopy(olderTaskStateId,newTaskStateId,EqptValveStateEnum.INProduction.getStateFlag(),eqptValveIdList);
        //4.复制配比
        taskFormulaCopy(olderTaskStateId,newTaskStateId);
        //5.复制点胶设定参数
        copyTaskEqptGlueDosage(olderTaskStateId,newTaskStateId);
        if(updateChipArea.equals(0)){
            if(compulsoryPass.equals(0)){
                //修改判定NG的文件 的JudageType
                bsTaskStateDao.updateFileJudageTypeWithEqptValveIdList(fileList,eqptValveIdList,JUDGET_TYPE_N_G_TO_O_K,fileStateJudgeNg);
            }else if(compulsoryPass.equals(1)){
                //修改判定NG的文件 的JudageType
                bsTaskStateDao.updateFileJudageTypeWithEqptValveIdList(fileList,eqptValveIdList,GET_JUDGE_TYPE_FORCE_TO_O_K,fileStateJudgeNg);
            }

            //6.修改文件状态
            this.bsTaskStateDao.updateUploadFileStateNGToOK(fileList,eqptValveIdList);
        }
        if(isJudgeSynchronizationFormula){
            //juageSynchronizationFormula(olderTaskStateId,userId);
            aiTaskFormulaForFile(fileList,userId);
        }
        log.info("当前方法的为  {取消NG}   {cancelNG} === end");
        return ResultUtils.success();
    }

    private final  static  Integer JUDGE_TYPE_O_K = 0;//直接判定ok
    private final  static  Integer JUDGET_TYPE_N_G_TO_O_K = 1;//取消NG
    private final  static  Integer GET_JUDGE_TYPE_FORCE_TO_O_K = 2;//强制通过
    /**
     * 测试OK
     * 1.修改文件状态判定为OK
     * (如果是量产就结束了)
     * 2.修改之前的状态
     * 3.新增状态
     * 4.复制阀体
     * 5.复制配比
     * 6.复制点胶设定参数
     * @param taskId
     * @param eqptValveId
     * @param userId
     */
    @Transactional
    @Override
    public Result testOk(Long taskStateId, Long eqptValveId, Long userId)throws QuException{
        log.info("当前方法的为  {测试OK}   {testOk}");
        //log.info("当前的工单taskId：{}", taskId);
        log.info("当前的工单测试OK的阀体Id->eqptValveId：{}", eqptValveId);
        log.info("当前的用户ID->userId：{}", userId);
        Long newTaskDfId = null;
        Long olderTaskStateId = taskStateId;
        Long newTaskStateId = null;
        //是否需要新增状态
        Boolean isCopy = false;
        //判定是否需要同步
        Boolean isJudgeSynchronizationFormula = false;
        //获取当前的工单状态数据
        //BsTaskState bsTaskState = this.bsTaskStateDao.getActiveTaskStateAllInfoWithFileIdList(taskId);
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);

        log.info("当前的工单状态taskStateId：{}", taskStateId);
        log.info("当前的工单状态：{}", TaskEnum.stateFlagOf(taskStateForDatabase.getTaskDfId()).getStateName());
        String fileList = taskStateForDatabase.getFileidList();
        log.info("当前的工单状态对应的文件ID列表：{}",fileList);


        //工单状态定义id
        Long taskDfId = taskStateForDatabase.getTaskDfId();
        //设置判定类型(未判定的)
        bsTaskStateDao.updateFileJudageTypeNOJudge(fileList,eqptValveId,JUDGE_TYPE_O_K);
        //1.修改文件状态把该阀体没有判定的文件判定为OK
        this.bsTaskStateDao.updateFileNoJudgeToOKWithList(fileList,eqptValveId,userId);

        //试样前测中
        if(taskDfId.equals(TaskEnum.TaskSamplePreTest.getStateFlag())){
            isCopy = true;
            newTaskDfId = TaskEnum.TaskSamplePreTestOK.getStateFlag();
            //试样前测通过
        }else if(taskDfId.equals(TaskEnum.TaskSamplePreTestOK.getStateFlag())){
            isCopy = true;
            //批量生产阶段
            newTaskDfId = TaskEnum.TaskBatchProduction.getStateFlag();
            isJudgeSynchronizationFormula = true;
            //批量生产
        }else if(taskDfId.equals(TaskEnum.TaskBatchProduction.getStateFlag())){
            return ResultUtils.success();
          //批量生产阀体NG
        }else if(taskDfId.equals(TaskEnum.TaskBatchProductionValveNG.getStateFlag())){
            return ResultUtils.success();
        }else{
            log.info("状态异常,无法NG");
            String errStr = "状态异常,无法NG";
            log.info("当前方法的为  {测试OK}   {testOk} === end");
            return ResultUtils.error(1,errStr);
        }
        if(isCopy) {
            //工单状态ID
           /* olderTaskStateId = bsTaskState.getId();
            bsTaskState.setCheckUser(userId);
            bsTaskState.setUpdateUser(userId);
            bsTaskState.setIsActive(false);
            bsTaskState.setSolutionType((byte) 0);//成功
            //2.修改之前的状态
            this.bsTaskStateDao.updateBsTaskStatesById(bsTaskState);
            //3.新增状态
            bsTaskState.setIsActive(true);
            bsTaskState.setCreator(userId);
            bsTaskState.setTaskDfId(newTaskDfId);
            Integer num = 0;
            num = this.bsTaskStateDao.insertSelectiveNoWithFileIdList(bsTaskState);
            if(num == 0){
                throw  new QuException(1,"重复调用");
            }
            newTaskStateId = bsTaskState.getId();*/
            bsTaskStateDao.updateTaskStateToNotActive(taskStateId);
            taskStateForDatabase.setTaskDfId(newTaskDfId);
            bsTaskStateDao.addTaskState(taskStateForDatabase);
            newTaskStateId = taskStateForDatabase.getId();
            //4.复制阀体 -- 只限制为生产中的
            taskEeqptValveProductCopy(olderTaskStateId, newTaskStateId);
            //5.复制配比
            taskFormulaCopy(olderTaskStateId, newTaskStateId);
            //6.复制点胶设定参数
            copyTaskEqptGlueDosage(olderTaskStateId, newTaskStateId);
        }
        //判定是否需要同步
        if(isJudgeSynchronizationFormula){
            log.info("当前方法的为  {测试OK}   {testOk} === end");
            //return juageSynchronizationFormula(olderTaskStateId,userId);
            return aiTaskFormulaForFile(fileList,userId);
        }

        //当所有的状态为ok(进入该方法即为ok)时，往算法模型表中新增修改数据。没有新增有则修改
        //根据当前状态单查询原有数据
        TAlgorithmModel tam = this.bsTaskStateDao.getTAlgorithmModel(taskStateId);

        if(tam != null && !"".equals(tam)){
            Long modelId = taskStateForDatabase.getModelId();//modelId:当前状态对应的算法模型
            List<TModelFormula> tModelFormulas = this.tAiModelMapper.findTModelFormula(modelId);
            if(tModelFormulas == null || "".equals(tModelFormulas)){
                ResultUtils.error(1,"当前配比为空");
            }

            List<TAlgorithmModel> tAlgorithmModels = tAlgorithmModelDao.selectTAlgorithmModel();

            for (TModelFormula tmf:tModelFormulas) {
                if(tam.getFileName() != null && !"".equals(tam.getFileName())){
                    String[] split1 = tam.getFileName().split("/");
                    String[] split2 = split1[4].split("_");
                    tam.setFileName(split2[0]);
                }

                tam.setCenterXy(tam.getCieX() + "," + tam.getCieY());
                tam.setScaffoldParam(tam.getParam1() + "*" + tam.getParam2() + "*" + tam.getParam3() + "*" + tam.getParam4() + "*" + tam.getParam5());
                if(tam.getWlMin() == null || "".equals(tam.getWlMin())){
                    tam.setChipWave(tam.getWlMax().longValue());
                }else if(tam.getWlMax() == null || "".equals(tam.getWlMax())){
                    tam.setChipWave(tam.getWlMin().longValue());
                }else {
                    Double v = (tam.getWlMin() + tam.getWlMax()) / 2;
                    tam.setChipWave(v.longValue());
                }
                //tam.setChipWave(tam.getWlMin() + "-" + tam.getWlMax());

                tam.setARatio(tmf.getGlueAMaterial().getRatio());
                tam.setBRatio(tmf.getGlueBMaterial().getRatio());
                if(tmf.getAntiStarchMaterial() != null && !"".equals(tmf.getAntiStarchMaterial())){
                    tam.setCRatio(tmf.getAntiStarchMaterial().getRatio());
                }
                if(tmf.getTPhosphors() != null && tmf.getTPhosphors().size() > 0 ){
                    List<TMaterialFormula> tPhosphorslist = this.bsTaskFormulaDao.getBsTaskFormulaPhosphorsByTaskFormulaId(taskStateId,tmf.getBomId());
                    tmf.setTPhosphors(tPhosphorslist);
                    //tam.setTPhosphors(tmf.getTPhosphors());
                    tam.setP1Id(tmf.getTPhosphors().get(0).getMaterialId());
                    tam.setP1Name(tmf.getTPhosphors().get(0).getSpec());
                    tam.setP1Wave(tmf.getTPhosphors().get(0).getPeakWavelength());
                    tam.setP1Ratio(tmf.getTPhosphors().get(0).getRatio());
                    tam.setP2Id(tmf.getTPhosphors().get(1).getMaterialId());
                    tam.setP2Name(tmf.getTPhosphors().get(1).getSpec());
                    tam.setP2Wave(tmf.getTPhosphors().get(1).getPeakWavelength());
                    tam.setP2Ratio(tmf.getTPhosphors().get(1).getRatio());
                    boolean contains = tmf.getTPhosphors().contains(tmf.getTPhosphors().get(2));
                    if(contains){
                        tam.setP3Id(tmf.getTPhosphors().get(2).getMaterialId());
                        tam.setP3Name(tmf.getTPhosphors().get(2).getSpec());
                        tam.setP3Wave(tmf.getTPhosphors().get(2).getPeakWavelength());
                        tam.setP3Ratio(tmf.getTPhosphors().get(2).getRatio());
                    }


                }

                boolean boo = false;
                for (TAlgorithmModel ta:tAlgorithmModels) {

                    if(tam.getScaffoldId().intValue() == ta.getScaffoldId().intValue() && tam.getChipId().intValue() == ta.getChipId().intValue() && tam.getCt().intValue() == ta.getCt().intValue() && tam.getP1Id().intValue() == ta.getP1Id().intValue() && tam.getARatio().equals(ta.getARatio())){
                        //有则修改，没有新增
                        log.info("当前的方法为修改");
                        tAlgorithmModelDao.updateTAlgorithmMode(tam);
                        return ResultUtils.success();
                    }
                }
                log.info("当前的方法为新增");
                tAlgorithmModelDao.addTAlgorithmMode(tam);
            }


        }



        log.info("当前方法的为  {测试OK}   {testOk} === end");
        return ResultUtils.success();
    }



    private static final Byte FILE_STATENO = -1;//未判定
    private static final Byte FILE_STATEOK = 0;//判定通过
    private static final Byte FILE_STATENG = 1;//判定NG

    /**
     * 复制配比
     * @param olderTaskStateId
     * @param newTaskStateId
     */
    @Transactional
    public void taskFormulaCopy(Long olderTaskStateId,Long newTaskStateId)throws QuException{
        if(olderTaskStateId == null || newTaskStateId == null){
            new QuException(1,"新的工单状态Id或者旧的工单状态Id为空");
        }
        //获取工单状态和BOM关系表
        List<BsTaskFormulaMix>  bsTaskFormulaList = this.bsTaskFormulaDao.getBsTaskFormulaMix(olderTaskStateId);
        if(bsTaskFormulaList == null && bsTaskFormulaList.size() == 0){
            log.info("taskStateId{}当前状态无配比",olderTaskStateId);
            return;
        }
        List<BsTaskFormulaDtl> bsTaskFormulaDtlList = new ArrayList<>();
        for (BsTaskFormulaMix t:
        bsTaskFormulaList) {
            BsTaskFormula bsTaskFormula = new BsTaskFormula();
            bsTaskFormula.setTaskBomId(t.getTaskBomId());
            bsTaskFormula.setTaskStateId(newTaskStateId);
            this.bsTaskFormulaDao.insertSelective(bsTaskFormula);

            for (BsTaskFormulaDtl t2:
                 t.getBsTaskFormulaDtlList()) {
                t2.setTaskFormulaId(bsTaskFormula.getId());
                //bsTaskFormulaDtlList.add(t2);
                this.bsTaskFormulaDtlDao.insert(t2);
            }

        }

        //this.bsTaskFormulaDtlDao.batchInsert(bsTaskFormulaDtlList);

    }


    /**
     * 复制点胶设定参数
     * @param olderTaskStateId
     * @param newTaskStateId
     */
    @Transactional
    public void copyTaskEqptGlueDosage(Long olderTaskStateId,Long newTaskStateId){
        if(olderTaskStateId == null || newTaskStateId == null){
            new QuException(1,"新的工单状态Id或者旧的工单状态Id为空");
        }
        if(olderTaskStateId > newTaskStateId){
            new QuException(1,"新旧工单状态异常");
        }

        List<BsEqptGuleDosage> bsEqptGuleDosageList = this.bsEqptValveStateDao.getTaskEqptValueDosageList(olderTaskStateId);
        if(bsEqptGuleDosageList == null || bsEqptGuleDosageList.size() == 0){
            log.info("当前工单状态taskStateId{},无点胶设定参数",olderTaskStateId);
            return;
        }
        for (BsEqptGuleDosage t:
        bsEqptGuleDosageList) {
            t.setTaskStateId(newTaskStateId);
        }
        bsEqptValveStateDao.batchInsertTaskEqptValueDosage(bsEqptGuleDosageList);
    }


    /**
     * 工单阀体复制加修改单个阀体的阀体状态
     * @param olderTaskStateId
     * @param newTaskStateId
     */
    public void taskEeqptValveCopy(Long olderTaskStateId,Long newTaskStateId,Long updateToEqptstate,Long eqptValveId){
        if(olderTaskStateId == null || newTaskStateId == null){
            new QuException(1,"新的工单状态Id或者旧的工单状态Id为空");
        }
        if(olderTaskStateId > newTaskStateId){
            new QuException(1,"新旧工单状态异常");
        }
        //获取未关闭的
        List<BsEqptValveState> olderEqptValveList = bsEqptValveStateDao.getTaskStateEqptValve(olderTaskStateId);
        List<BsEqptValveState> newEqptValveList = new ArrayList<>();
        if(olderEqptValveList == null || olderEqptValveList.size() == 0){
            log.info("当前工单状态taskStateId{},无阀体",olderTaskStateId);
            return;
        }
        for (BsEqptValveState t:
                olderEqptValveList) {
            //如果有需要修改状态的阀体
            if(updateToEqptstate!=null && t.getEqptValveId().equals(eqptValveId)){
                t.setEqptValveDfId(updateToEqptstate);
            }
            t.setTaskStateId(newTaskStateId);
            newEqptValveList.add(t);
        }
        bsEqptValveStateDao.batchInsert(newEqptValveList);
    }

    /**
     * 工单阀体复制加批量修改阀体的阀体状态
     * @param olderTaskStateId
     * @param newTaskStateId
     */
    public void taskEeqptValveCopy(Long olderTaskStateId,Long newTaskStateId,Long updateToEqptstate,List<Long> eqptValveIdList){
        if(olderTaskStateId == null || newTaskStateId == null){
            new QuException(1,"新的工单状态Id或者旧的工单状态Id为空");
        }
        if(olderTaskStateId > newTaskStateId){
            new QuException(1,"新旧工单状态异常");
        }
        //获取未关闭的
        List<BsEqptValveState> olderEqptValveList = bsEqptValveStateDao.getTaskStateEqptValve(olderTaskStateId);
        List<BsEqptValveState> newEqptValveList = new ArrayList<>();
        if(olderEqptValveList == null || olderEqptValveList.size() == 0){
            log.info("当前工单状态taskStateId{},无阀体",olderTaskStateId);
            return;
        }
        for (BsEqptValveState t1:
                olderEqptValveList) {
            //如果有需要修改状态的阀体
            if(updateToEqptstate!=null){
                for (Long t2:
                eqptValveIdList) {
                    if(t1.getEqptValveId().equals(t2)) {
                        t1.setEqptValveDfId(updateToEqptstate);
                    }
                }

            }
            t1.setTaskStateId(newTaskStateId);
            newEqptValveList.add(t1);
        }
        bsEqptValveStateDao.batchInsert(newEqptValveList);
    }

    /**
     * 工单阀体复制加批量修改阀体的阀体状态
     * @param olderTaskStateId
     * @param newTaskStateId
     */
    public void taskEeqptValveCopy(Long olderTaskStateId,Long newTaskStateId,Long updateToEqptstate){
        if(olderTaskStateId == null || newTaskStateId == null){
            new QuException(1,"新的工单状态Id或者旧的工单状态Id为空");
        }
        if(olderTaskStateId > newTaskStateId){
            new QuException(1,"新旧工单状态异常");
        }
        //获取未关闭的
        List<BsEqptValveState> olderEqptValveList = bsEqptValveStateDao.getTaskStateEqptValve(olderTaskStateId);
        if(olderEqptValveList == null || olderEqptValveList.size() == 0){
            log.info("当前工单状态taskStateId{},无阀体",olderTaskStateId);
            return;
        }

        List<BsEqptValveState> newEqptValveList = new ArrayList<>();

        for (BsEqptValveState t:
                olderEqptValveList) {
            //如果有需要修改状态的阀体
            if(updateToEqptstate!=null){
                t.setEqptValveDfId(updateToEqptstate);
            }
            t.setTaskStateId(newTaskStateId);
            newEqptValveList.add(t);
        }
        bsEqptValveStateDao.batchInsert(newEqptValveList);
    }


    /**
     * 工单阀体复制只限于在生产中的阀体
     * @param olderTaskStateId
     * @param newTaskStateId
     */
    public void taskEeqptValveProductCopy(Long olderTaskStateId,Long newTaskStateId){
        if(olderTaskStateId == null || newTaskStateId == null){
            new QuException(1,"新的工单状态Id或者旧的工单状态Id为空");
        }
        if(olderTaskStateId > newTaskStateId){
            new QuException(1,"新旧工单状态异常");
        }
        //获取未关闭的
        List<BsEqptValveState> olderEqptValveList = bsEqptValveStateDao.getTaskStateProductEqptValve(olderTaskStateId);
        List<BsEqptValveState> newEqptValveList = new ArrayList<>();
        if(olderEqptValveList == null || olderEqptValveList.size() == 0){
            log.info("当前工单状态taskStateId{},无阀体",olderTaskStateId);
            return;
        }
        for (BsEqptValveState t:
                olderEqptValveList) {
            t.setTaskStateId(newTaskStateId);
            newEqptValveList.add(t);
        }
        bsEqptValveStateDao.batchInsert(newEqptValveList);
    }


    /**
     * 重新测试 针对单个阀体下 -- 要不对单个文件进行重新测试，要不对所有未文件进行重新测试
     * 如果是这个阀体的所有文件则新增工单工单状态数据
     * 1.删除工单
     * 2.修改之前的状态
     * 3.新增状态
     * 4.复制阀体
     * 5.复制配比
     * 6.复制点胶设定参数
     * @param taskId
     * @param fileId
     * @return
     */
    @Transactional
    @Override
    public Result allDiscard(Long taskStateId, Long fileId, Long userId,Long eqptValveId)throws QuException{
        log.info("当前方法的为  {重新测试}   {allDiscard}");
        //log.info("当前的工单taskId：{}", taskId);
        log.info("taskStateId: {}",taskStateId);
        log.info("当前的工单测试OK的阀体Id->eqptValveId：{}", eqptValveId);
        log.info("当前的用户ID->userId：{}", userId);

        Long olderTaskStateId = null;
        Long newTaskStateId = null;

        //获取当前的工单状态数据
        //BsTaskState bsTaskState = this.bsTaskStateDao.getActiveTaskStateAllInfoWithFileIdList(taskId);
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);

        //log.info("当前的工单状态taskStateId：{}", taskStateId);
        log.info("当前的工单状态：{}", TaskEnum.stateFlagOf(taskStateForDatabase.getTaskDfId()).getStateName());
        String fileIdList = taskStateForDatabase.getFileidList();
        log.info("当前的工单状态对应的文件ID列表：{}", fileIdList);
        //1.删除这个阀体没有判定的文件
        bsTaskStateDao.updateFileNoJudgeToDelete(fileId,fileIdList,eqptValveId,userId);
        if(fileId != null){
            log.info("当前的工单重新测试的文件ID-->fileId：{}", fileId);
            log.info("当前的重新测试针对单个阀体的单个未判定文件");
            log.info("当前方法的为  {重新测试}   {allDiscard}  === end");
            return  ResultUtils.success();
        }

        log.info("当前的重新测试针对单个阀体的所有未判定文件");
       /* olderTaskStateId = bsTaskState.getId();
        bsTaskState.setCheckUser(userId);
        bsTaskState.setUpdateUser(userId);
        bsTaskState.setIsActive(false);
        bsTaskState.setSolutionType((byte) 5);//数据批量否定
        bsTaskState.setIsRetest(true);//把之前的状态改为重测
        //2.修改之前的状态
        this.bsTaskStateDao.updateBsTaskStatesById(bsTaskState);
        //3.新增状态
        bsTaskState.setIsActive(true);
        bsTaskState.setCreator(userId);
        bsTaskState.setIsRetest(false);
        Integer num = 0;
        num = this.bsTaskStateDao.insertSelectiveNoWithFileIdList(bsTaskState);
        if( num == 0){
            throw  new QuException(1,"重复调用");
        }
        newTaskStateId = bsTaskState.getId();
        //4.复制阀体
        taskEeqptValveCopy(olderTaskStateId, newTaskStateId, null);
        //5.复制配比
        taskFormulaCopy(olderTaskStateId, newTaskStateId);
        //6.复制点胶设定参数
        copyTaskEqptGlueDosage(olderTaskStateId, newTaskStateId);*/
        log.info("当前方法的为  {重新测试}   {allDiscard}  === end");
        return ResultUtils.success();
    }


    /**
     * 获取工单当前的活跃状态
     * 加入是否重新试样的字段标识
     * @param taskId
     * @param taskStateId
     * @return
     */
    @Override
    public Result getTaskDtl(Long taskStateId){
        TaskState taskState = this.bsTaskStateDao.getMainTaskStateInfo(taskStateId);
        //是否重新试样
        Integer num = this.bsTaskStateDao.findMainProcessISReset(taskState.getTaskId());
        if(num > 1){
            taskState.setIsRestSY(true);
        }
        return ResultUtils.success(taskState);
    }


    /**
     * 新增工单阀体addTaskEqptValve包含工单状对阀体和工单状态对阀体点胶设定参数
     * 新增点胶
     * 新增工单状态和阀体
     * 新增热表
     * @return
     */
    @Transactional
    @Override
    public Result addTaskEqptValve(List<BsEqptGuleDosage> list){
        log.info("当前方法的为  {新增工单阀体}   {addTaskEqptValve}");

        //阀体状态
        Long eqptValveState = null;
        if(list == null || list.size() == 0){
            return ResultUtils.error(1,"没有新增的阀体无法新增");
        }

        //阀体运行热表
        List<BsEqptTaskRuntime> bsEqptTaskRuntimeList = new ArrayList<>();
        //去重防止前端传的数据有吴
        List<BsEqptGuleDosage> distinctByEqptValveIdAndTaskStateId = BsEqptGuleDosage_DISTINCT.distinctMethod(list);
        if(distinctByEqptValveIdAndTaskStateId.size() != list.size()){
            return ResultUtils.error(1,"点胶设定参数设定阀体数据重复无法新增");
        }
        //工单
        Long taskId = list.get(0).getTaskId();
        //工单状态
        Long taskStateId = list.get(0).getTaskStateId();
        //BsTaskState bsTaskState = this.bsTaskStateDao.getActiveTaskStateAllInfoWithFileIdList(taskId);
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);

        log.info("当前的工单taskId：{}", taskId);
        log.info("当前的工单状态taskStateId：{}", taskStateId);
        log.info("当前的工单状态：{}", TaskEnum.stateFlagOf(taskStateForDatabase.getTaskDfId()).getStateName());

        if(taskStateForDatabase == null){
            return  ResultUtils.error(1,"找不到当前工单的数据");
        }else if(taskStateForDatabase.getTaskDfId().equals(TaskEnum.TASKCLOSE.getStateFlag())){
            return  ResultUtils.error(1,"当前工单已关闭");
        }else if(taskStateForDatabase.getTaskDfId().equals(TaskEnum.TaskPendingSample.getStateFlag())){
            eqptValveState = EqptValveStateEnum.NOProduction.getStateFlag();
        }else{
            eqptValveState = EqptValveStateEnum.INProduction.getStateFlag();
        }

        //新增点胶设定参数
        this.bsEqptValveStateDao.batchInsertTaskEqptValueDosage(list);
        //阀体list
        List<BsEqptValveState> list1 = new ArrayList<>();

        for (BsEqptGuleDosage t:
        list) {
           BsEqptValveState bsEqptValveState = new BsEqptValveState();
           bsEqptValveState.setEqptValveDfId(eqptValveState);
           bsEqptValveState.setEqptValveId(t.getEqptValveId());
           bsEqptValveState.setTaskStateId(t.getTaskStateId());
           list1.add(bsEqptValveState);

           BsEqptTaskRuntime  bsEqptTaskRuntime = new BsEqptTaskRuntime();
           bsEqptTaskRuntime.setEqptValveId(t.getEqptValveId());
           bsEqptTaskRuntime.setTaskId(t.getTaskId());
           bsEqptTaskRuntimeList.add(bsEqptTaskRuntime);
        }
        //新增阀体
        this.bsEqptValveStateDao.batchInsert(list1);
        //新增工单热表
        this.bsEqptValveStateDao.InsertBsEqptTaskRuntime(bsEqptTaskRuntimeList);
        log.info("当前方法的为  {新增工单阀体}   {addTaskEqptValve} ===  end");
        return ResultUtils.success();
    }

//    public static void main(String[] args) {
//        List<BsEqptGuleDosage> list = new ArrayList<>();
//        Set<BsEqptGuleDosage> studentSet = new TreeSet();
//        studentSet.addAll(students)
//    }
    /**
     * 前测NG阀体关掉，状态变为试样前测中（状态2 试样前测）
     * 品质测试NG阀体关掉，状态变为试样前测中（状态2  试样前测）
     * 批量阀体NG关掉，只有一个NG，关掉状态为量产（状态6 批量生产），多个NG阀体，关掉一个，状态还为批量阀体NG（状态7 批量阀体NG）
     * 关闭的阀体不能看到NG记录
     *
     * 关闭阀体(如果状态变更并且量产工单还有一个生产中的阀体则复制)
     * @param eqptValveClose
     */
    @Transactional
    @Override
    public Result closeTaskEqptValve(EqptValveClose eqptValveClose) throws QuException{
        log.info("当前方法的为  {关闭阀体}   {closeTaskEqptValve} ");
        List<Long> eqptValveListDelte = eqptValveClose.getEqptValveListDelte();
        log.info(" 要关闭的阀体的数量：{}",eqptValveListDelte.size());
        log.info("");

        Long oldTaskStateId = eqptValveClose.getTaskStateId();//旧的工单状态ID
        Long newTaskStateId = null;//新的工单状态ID
        Long oldTaskStateDfId = null;//旧的工单状态定义字段
        Long newTaskStateDfId = null;//新的工单状态定义字段
        Long taskId = eqptValveClose.getTaskId();
        Boolean isChangeState = false;//是否要改变工单状态
        Boolean isCopyEqptValve = false;//是否要复制阀体
        Long userId = eqptValveClose.getUserId();
        //获取工单最新状态信息
        //BsTaskState bsTaskState = this.bsTaskStateDao.getActiveTaskStateAllInfoWithFileIdList(taskId);
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(oldTaskStateId);
        //oldTaskStateId = bsTaskState.getId();
        oldTaskStateDfId = taskStateForDatabase.getTaskDfId();

        //List<Long> eqptValveRuntimeList = this.bsTaskStateDao.getRuntimeEqptValveId(taskId);
        List<Long> eqptValveRuntimeList = bsTaskStateDao.getTaskStateRunEqptValveList(oldTaskStateDfId);

        log.info(" 工单{oldTaskStateId} 工单状态ID 为：{}",oldTaskStateId);

        log.info(" 工单{oldTaskStateDfId} 工单状态定义字段为：{}",oldTaskStateDfId);

        if(oldTaskStateDfId.equals(TaskEnum.TaskSamplePreTestNG.getStateFlag())){
            isChangeState = true;
            newTaskStateDfId = TaskEnum.TaskSamplePreTest.getStateFlag();
        }
        else if(oldTaskStateDfId.equals(TaskEnum.TaskSampleQualityTestNG.getStateFlag())){
            isChangeState = true;
            newTaskStateDfId = TaskEnum.TaskSamplePreTest.getStateFlag();
        }

        else if(oldTaskStateDfId.equals(TaskEnum.TaskBatchProductionValveNG.getStateFlag())){
            //把所有阀体都关闭则量产
            //如果关闭NG阀体则量产
            //其它的都不变
            List<Long> eqptValveNGIdList = this.bsTaskStateDao.getNGEqptValveId(oldTaskStateId);


            //1.只变状态不复制阀体
            if(eqptValveListDelte.containsAll(eqptValveNGIdList) && eqptValveListDelte.containsAll(eqptValveRuntimeList)){
                isChangeState = true;
                newTaskStateDfId = TaskEnum.TaskBatchProduction.getStateFlag();
                isCopyEqptValve = false;
            }
            //2.包含所有NG但不包含所有的阀体，要复制阀体
            else if(eqptValveListDelte.containsAll(eqptValveNGIdList) && !eqptValveListDelte.containsAll(eqptValveRuntimeList)){
                eqptValveRuntimeList.removeAll(eqptValveListDelte);
                isChangeState = true;
                isCopyEqptValve = true;
                newTaskStateDfId = TaskEnum.TaskBatchProduction.getStateFlag();
            }
            //3.没有包含全部NG的阀体那么只修改阀体就可以了
        }


        if(isChangeState){
            //工单状态ID
          /*  bsTaskState.setCheckUser(userId);
            bsTaskState.setUpdateUser(userId);
            bsTaskState.setIsActive(false);
            //2.修改之前的状态
            this.bsTaskStateDao.updateBsTaskStatesById(bsTaskState);
            //1.新增状态
            bsTaskState.setIsActive(true);
            bsTaskState.setCreator(userId);
            bsTaskState.setTaskDfId(newTaskStateDfId);
            Integer num = 0;
            num = this.bsTaskStateDao.insetSelectiveWithOlderFileIdList(bsTaskState);
            if(num == 0){
                throw  new QuException(1,"重复调用");
            }
            newTaskStateId = bsTaskState.getId();*/
            bsTaskStateDao.updateTaskStateToNotActive(oldTaskStateId);
            taskStateForDatabase.setTaskDfId(newTaskStateDfId);
            bsTaskStateDao.addTaskState(taskStateForDatabase);
            newTaskStateId = taskStateForDatabase.getId();

            //4.复制配比
            taskFormulaCopy(oldTaskStateId,newTaskStateId);
        }

        if(isCopyEqptValve){
            this.bsEqptValveStateDao.insetEqptValveList(newTaskStateId,eqptValveRuntimeList,EqptValveStateEnum.INProduction.getStateFlag());
            //去除关闭掉的之外剩余的阀体
            List<Long> remainingeqptValveList =   eqptValveRuntimeList.stream().filter(o -> !eqptValveListDelte.contains(o)).collect(toList());
            taskEqptGlueDosageOnlyList(oldTaskStateId,newTaskStateId,remainingeqptValveList);
        }
        //删除热表
        this.bsEqptValveStateDao.deleteBsEqptTaskRuntime(eqptValveListDelte,taskId);
        log.info(" 工单Id为：{}",taskId);
        //设定阀体状态
        this.bsEqptValveStateDao.updateBsTaskStateEqptValve(eqptValveListDelte,EqptValveStateEnum.CLOSE.getStateFlag(),eqptValveClose.getTaskStateId());
        log.info("当前方法的为  {关闭阀体}   {closeTaskEqptValve} === end");
        return ResultUtils.success();
    }


    /**
     * 复制点胶设定参数
     * @param olderTaskStateId
     * @param newTaskStateId
     */
    @Transactional
    public void taskEqptGlueDosageOnlyList(Long olderTaskStateId,Long newTaskStateId,List<Long> remainingeqptValveList){
        if(olderTaskStateId == null || newTaskStateId == null){
            new QuException(1,"新的工单状态Id或者旧的工单状态Id为空");
        }
        if(olderTaskStateId > newTaskStateId){
            new QuException(1,"新旧工单状态异常");
        }

        List<BsEqptGuleDosage> bsEqptGuleDosageList = this.bsEqptValveStateDao.getTaskEqptValueDosageList(olderTaskStateId);
        List<BsEqptGuleDosage> addList = new ArrayList<>();
        if(bsEqptGuleDosageList == null || bsEqptGuleDosageList.size() == 0){
            log.info("当前工单状态taskStateId{},无点胶设定参数",olderTaskStateId);
            return;
        }
        for (BsEqptGuleDosage t:
                bsEqptGuleDosageList) {
            t.setTaskStateId(newTaskStateId);
            for (Long t2:
                    remainingeqptValveList) {
                if(t.getEqptValveId().equals(t2)){
                    addList.add(t);
                    break;
                }
            }
        }
        if(addList.size() > 0) {
            bsEqptValveStateDao.batchInsertTaskEqptValueDosage(bsEqptGuleDosageList);
        }
    }

    /**
     * 修改点胶设定参数(较复杂)
     * 1.判断工单状态，如果是其它状态状态则只是修改不改变,试样前测NG，试样品质NG,和量产NG要改变
     * 2.如果是3种NG 修改之前的状态
     * 3.新增状态
     * 4.复制阀体
     * 5.复制配比
     * 6.复制点胶设定参数
     * 7.修改点胶设定参数
     * @param bsEqptValveDosageEadit
     * @return
     */
    @Transactional
    @Override
    public Result setEqptGlueDosage(BsEqptValveDosageEadit bsEqptValveDosageEadit) throws  QuException{
        log.info("当前方法的为  {修改点胶设定参数}   {setEqptGlueDosage} ");

        Long olderTaskStateId = null;
        Long newTaskStateId = null;
        Long newTaskDfId = null;
        Long oldTaskDfId = null;
        Long userId = bsEqptValveDosageEadit.getUserId();
        Long newEqptValveState = null;

        Boolean isXZ = false;//是否新增
        List<BsEqptGuleDosage> bsEqptGuleDosageList = bsEqptValveDosageEadit.getBsEqptGuleDosageList();
        if(bsEqptGuleDosageList == null && bsEqptGuleDosageList.size() == 0){
            return  ResultUtils.error(1,"后台没有取得要修改的阀体列表，无法修改");
        }
        //要修改的阀体列表
       /* List<Long> eqptValveList = new ArrayList<>();
        for (BsEqptGuleDosage t: bsEqptGuleDosageList) {
            eqptValveList.add(t.getEqptValveId());
        }*/
        //要修改的阀体ID列表
        List<Long> updateEqptValveIdList = bsEqptGuleDosageList.parallelStream().map(o -> o.getEqptValveId()).distinct().collect(toList());

        Long taskId = bsEqptGuleDosageList.get(0).getTaskId();
        olderTaskStateId = bsEqptGuleDosageList.get(0).getTaskStateId();
        //获取当前的工单状态数据
        //BsTaskState bsTaskState = this.bsTaskStateDao.getActiveTaskStateAllInfo(taskId);
        //olderTaskStateId = taskStateId;
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(olderTaskStateId);

        //获得工单当前的状态
        //oldTaskDfId = bsTaskState.getTaskDfId();
        oldTaskDfId = taskStateForDatabase.getTaskDfId();

        log.info("当前工单IDtaskId:{} ",taskId);
        log.info("当前工单taskStateId:{}",olderTaskStateId);
        log.info("当前工单状态：{} ",TaskEnum.stateFlagOf(oldTaskDfId).getStateName());

        //待试样
        if(oldTaskDfId.equals(TaskEnum.TaskPendingSample.getStateFlag())){
            newTaskDfId = TaskEnum.TaskPendingSample.getStateFlag();
            newEqptValveState = EqptValveStateEnum.NOProduction.getStateFlag();
            isXZ = false;
        }
        //试样前测中
        else if(oldTaskDfId.equals(TaskEnum.TaskSamplePreTest.getStateFlag())){
            newTaskDfId = TaskEnum.TaskSamplePreTest.getStateFlag();
            newEqptValveState = EqptValveStateEnum.INProduction.getStateFlag();
            isXZ = false;
        }
        //试样前测NG
        else if(oldTaskDfId.equals(TaskEnum.TaskSamplePreTestNG.getStateFlag())){
            newTaskDfId = TaskEnum.TaskSamplePreTest.getStateFlag();
            newEqptValveState = EqptValveStateEnum.INProduction.getStateFlag();
            isXZ = true;
        }
        //试样品质NG
        else if(oldTaskDfId.equals(TaskEnum.TaskSampleQualityTestNG.getStateFlag())){
            newTaskDfId = TaskEnum.TaskSamplePreTest.getStateFlag();
            newEqptValveState = EqptValveStateEnum.INProduction.getStateFlag();
            isXZ = true;
        }
        //批量阀体NG
        else if(oldTaskDfId.equals(TaskEnum.TaskBatchProductionValveNG.getStateFlag())){
            newEqptValveState = EqptValveStateEnum.INProduction.getStateFlag();
            //NG的阀体数量
            Integer num = bsEqptValveStateDao.getTaskStateNGEqptValveListNum(olderTaskStateId);
            //NG的阀体数量和修改点胶设定参数的阀体数量对比
            if(num <= bsEqptGuleDosageList.size()){
                isXZ = true;
                newTaskDfId = TaskEnum.TaskBatchProduction.getStateFlag();
            }else{

                isXZ = false;
            }

        }
        //批量生产中
        else if(oldTaskDfId.equals(TaskEnum.TaskBatchProduction.getStateFlag())){
            newEqptValveState = EqptValveStateEnum.INProduction.getStateFlag();
            newTaskDfId = TaskEnum.TaskBatchProduction.getStateFlag();
            isXZ = false;
        }
        //工单已关闭
        else if(oldTaskDfId.equals(TaskEnum.TASKCLOSE.getStateFlag())){
            return ResultUtils.error(1,"工单已关闭");
        }

        //不需要变更状态的点胶参数修改情况
        if(!isXZ){
            //修改阀体的点胶设定参数
            this.bsEqptValveStateDao.updateBsTaskStateEqptValveDsoge(olderTaskStateId,bsEqptGuleDosageList);
            //设定阀体状态把其状态改为生产中
            this.bsEqptValveStateDao.updateBsTaskStateEqptValve(updateEqptValveIdList,newEqptValveState,olderTaskStateId);
            log.info("当前方法的为  {修改点胶设定参数}   {setEqptGlueDosage} == end");
            //修改成功
            return  ResultUtils.success();
        }else{
            //olderTaskStateId = bsTaskState.getId();
          /*  bsTaskState.setCheckUser(userId);
            bsTaskState.setUpdateUser(userId);
            // 设置变更原因为 ----- 修改点胶量
            bsTaskState.setSolutionType((byte)2);
            bsTaskState.setIsActive(false);
            //2.修改之前的状态
            this.bsTaskStateDao.updateBsTaskStatesById(bsTaskState);
            //3.新增状态
            bsTaskState.setIsActive(true);
            bsTaskState.setCreator(userId);
            bsTaskState.setIsRetest(false);
            bsTaskState.setTaskDfId(newTaskDfId);
            Integer num = 0;
            num = this.bsTaskStateDao.insertSelectiveNoWithFileIdList(bsTaskState);
            if(num == 0){
                throw new QuException(1,"重复调用");
            }
            newTaskStateId = bsTaskState.getId();*/
            bsTaskStateDao.updateTaskStateToNotActive(olderTaskStateId);
            taskStateForDatabase.setTaskDfId(newTaskDfId);
            taskStateForDatabase.setFileidList("");
            bsTaskStateDao.addTaskState(taskStateForDatabase);
            newTaskStateId = taskStateForDatabase.getId();
            //4.复制阀体并且把修改点胶设定参数的阀体的状态改为生产中
            taskEeqptValveCopy(olderTaskStateId, newTaskStateId, EqptValveStateEnum.INProduction.getStateFlag(),updateEqptValveIdList);
            //5.复制配比
            taskFormulaCopy(olderTaskStateId, newTaskStateId);
            //6.复制点胶设定参数 并修改其值
            taskEqptGlueDosage(olderTaskStateId, newTaskStateId,bsEqptGuleDosageList);
        }
        log.info("当前方法的为  {修改点胶设定参数}   {setEqptGlueDosage} == end");
        return ResultUtils.success();
    }


    /**
     * 修改阀体点胶设定参数
     * @param olderTaskStateId 旧的工单状态ID
     * @param newTaskStateId 新的工单状态ID
     * @param bsEqptGuleDosageList 阀体点胶设定参数列表
     * @throws QuException
     */
    public  void taskEqptGlueDosage(Long olderTaskStateId,Long  newTaskStateId,List<BsEqptGuleDosage> bsEqptGuleDosageList) throws QuException{
        if(olderTaskStateId == null){
            new QuException(1,"原工单状态的ID为空");
        }
        if(newTaskStateId == null){
            new QuException(1,"现工单状态的ID为空");
        }
        if(newTaskStateId < olderTaskStateId){
            new QuException(1,"现工单状态的ID小于之前的工单状态");
        }
        if(bsEqptGuleDosageList==null || bsEqptGuleDosageList.size() == 0){
            new QuException(1,"没有要修改的点胶参数列表");
        }
        List<BsEqptGuleDosage> oldbsEqptGuleDosageList = this.bsEqptValveStateDao.getTaskEqptValueDosageList(olderTaskStateId);
        if(oldbsEqptGuleDosageList == null || oldbsEqptGuleDosageList.size() == 0 ){
            log.info("当前工单状态taskStateId{},无阀体点胶参数可复制",olderTaskStateId);
            return;
        }
        for (BsEqptGuleDosage t1:
                oldbsEqptGuleDosageList) {
            t1.setTaskStateId(newTaskStateId);
            for (BsEqptGuleDosage t2:
            bsEqptGuleDosageList) {
                if(t1.getEqptValveId().equals(t2.getEqptValveId())){
                    t1.setDosage(t2.getDosage());
                }
            }
        }
        bsEqptValveStateDao.batchInsertTaskEqptValueDosage(oldbsEqptGuleDosageList);
    }

    private final  static Integer IGNORE_RAR9 = 0;//忽略
    private final  static Integer NOT_IGNORE_RAR9 = 1;//不忽略

    /**
     * 编辑工单的配方
     * 0.首先看工单状态
     * 1.查看是否存在这个配方，如果有直接关联
     * 2.如果没有则首先新建 然后返回ID
     * 3.根据工单状态来决定新增工单状态还是变更工单配方
     * 4.配方和配比只要修改就记
     * @return
     */
    @Transactional
    @Override
    public Result editTaskAIModel(BsTaskAIModelEdit bsTaskAIModelEdit){

        log.info("当前方法的为  {编辑工单的配方}   {editTaskAIModel} ");
        Long olderTaskStateId = bsTaskAIModelEdit.getTaskStateId();
        //Long newTaskStateId = null;
        Long newTaskDfId = TaskEnum.TaskPendingSample.getStateFlag();
        Long oldTaskDfId = null;
        Long oldModelId = null;
        Long newModelId = null;


        //bomid
        Long bomId = bsTaskAIModelEdit.getBomId();
        //工单ID
        Long taskId = bsTaskAIModelEdit.getTaskId();
        //用户ID
        Long userId = bsTaskAIModelEdit.getUserId();
        //芯片波段ID
        List<Long> chipWlRankIdList = bsTaskAIModelEdit.getChipWlRankIdList();

        //获取当前的工单状态数据
        //BsTaskState bsTaskState = this.bsTaskStateDao.getActiveTaskStateAllInfo(taskId);
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(olderTaskStateId);
        //工单状态
        //oldTaskDfId = bsTaskState.getTaskDfId();
        oldTaskDfId = taskStateForDatabase.getTaskDfId();

        //olderTaskStateId = bsTaskState.getId();//工单状态ID
        oldModelId = taskStateForDatabase.getModelId();//模型ID

        log.info("当前工单ID taskId:{} ",taskId);
        log.info("当前工单taskStateId:{} ",olderTaskStateId);
        log.info("当前工单状态：{} ",TaskEnum.stateFlagOf(oldTaskDfId).getStateName());
        log.info("当前用户ID：{} ",userId);
        //每次修改配方都要把RaR9需求值为不忽略装态
        //bsTaskStateDao.updateBsTaskRaR9Require(taskId,NOT_IGNORE_RAR9);
        //bsTaskStateDao.updateBsTaskRaR9Require(olderTaskStateId,NOT_IGNORE_RAR9);
        taskStateForDatabase.setRar9Type(NOT_IGNORE_RAR9);
        //模型详情
        BsAIModelDtl oldbsAIModelDtl = this.tAiModelMapper.findAiModelDtlByModelId(oldModelId);
        //比较旧的bom和芯片波段
       /* if(oldbsAIModelDtl.getBomId().equals(bomId) && oldbsAIModelDtl.getChipWlRankId().equals(chipWlRankId)){
            return ResultUtils.error(1,"修改后的配方与原配方一致");
        }*/

        /*//查询新的配方是否存在
        BsAIModelDtl newbsAIModelDtl = this.tAiModelMapper.findAiModel(oldbsAIModelDtl.getTypeMachineId(),
                                                                        bomId,
                                                                        oldbsAIModelDtl.getOutputRequireMachineId(),
                                                                         chipWlRankId);*/
        //获取可能相同的生产搭配
        List<Long> oldmodeIdList = this.tAiModelMapper.findAiModelIdList(oldbsAIModelDtl.getTypeMachineId(),oldbsAIModelDtl.getOutputRequireMachineId(),bomId);
        for (Long modelId:
                oldmodeIdList) {
            //获取它的芯片波段集合再进行比较
            List<Long> oldchipRankIdList = this.tAiModelMapper.findAiModelBomchipRankIdList(modelId);
            if(ListUtil.isListEqual(chipWlRankIdList,oldchipRankIdList)){
                newModelId = modelId;
            }
        }
        //boolean isfindWithRatio = true;//是否需要寻找与之相关的配比
        //如果新的配方数据库中不存在 就要现在配方库中新建
        if(newModelId == null){
            TAiModel record = new TAiModel();
            record.setColorRegionId(oldbsAIModelDtl.getColorRegionId());
            record.setCreator(userId);
            record.setOutputRequireMachineId(oldbsAIModelDtl.getOutputRequireMachineId());
            record.setTypeMachineId(oldbsAIModelDtl.getTypeMachineId());

            //bom组合list
            List<TBom> tBoms = new ArrayList<>();
            TBom tBom = new TBom();
            tBom.setId(bomId);
            tBoms.add(tBom);
            record.setTBoms(tBoms);

            record.setTChipWlRankList(chipWlRankIdList);

            newModelId = addTAiModel(record);//新建生产搭配
            //isfindWithRatio = false;
        }

           /* bsTaskState.setCheckUser(userId);
            bsTaskState.setUpdateUser(userId);
            bsTaskState.setIsActive(false);
            //设定之前的原因为修改BOM
            bsTaskState.setSolutionType((byte)4);
            //2.修改之前的状态
            this.bsTaskStateDao.updateBsTaskStatesById(bsTaskState);

            bsTaskState.setIsActive(true);
            bsTaskState.setCreator(userId);
            bsTaskState.setTaskDfId(TaskEnum.TaskPendingSample.getStateFlag());
            bsTaskState.setModelId(newModelId);
            Integer num = 0;
            //1.新增工单状态数据
            num = this.bsTaskStateDao.insertSelectiveNoWithFileIdList(bsTaskState);
            if(num == 0){
                throw new QuException(1,"重复调用");
            }*/
           /* //4.删除阀体工单热表
            this.bsTaskStateDao.deleteBsEqptTaskRuntimeByTaskId(taskId);*/
           bsTaskStateDao.updateTaskStateToNotActive(olderTaskStateId);
           taskStateForDatabase.setTaskDfId(newTaskDfId);
           taskStateForDatabase.setModelId(newModelId);
           taskStateForDatabase.setModelCreateTime(Convert.getNow());
           taskStateForDatabase.setModelCreator(userId);
           taskStateForDatabase.setModelVersion(taskStateForDatabase.getModelVersion() + 1);//配方版本号加1

            //配比库中寻找配比
            Integer num = tAiModelMapper.findExitFormulaByModelId(newModelId);
           //去数据库里面寻找关联配比(记得去修改配比编辑)
           if(num > 0){
                taskStateForDatabase.setRatioVersion(0);
                taskStateForDatabase.setRatioSource(RatioSourceEnum.RATIO_DATABASE.getFlag());
                taskStateForDatabase.setRatioCreator(userId);
                taskStateForDatabase.setRatioCreateTime(Convert.getNow());
           }
           taskStateForDatabase.setFileidList("");
           bsTaskStateDao.addTaskState(taskStateForDatabase);
           final Long newTaskStateId  = taskStateForDatabase.getId();
           if(num > 0){
               List<TModelFormula> tModelFormulas = this.tAiModelMapper.findTModelFormula(newModelId);//从配比库中获取配比信息

                 tModelFormulas.forEach(t -> {
                   BsTaskFormula bsTaskFormula = new BsTaskFormula();
                   bsTaskFormula.setTaskStateId(newTaskStateId);
                   bsTaskFormula.setTaskBomId(t.getBomId());
                   //新增工单状态对BOM表
                   bsTaskFormulaDao.insertSelective(bsTaskFormula);

                   //转换
                   List<TMaterialFormula> temp = new ArrayList<>();
                   TMaterialFormula diffusionPowderMaterial =  t.getDiffusionPowderMaterial();
                   TMaterialFormula antiStarchMaterial = t.getAntiStarchMaterial();
                   List<TMaterialFormula> tPhosphors = t.getTPhosphors();
                   TMaterialFormula glueAMaterial = t.getGlueAMaterial();
                   glueAMaterial.setMaterialClass(MaterialClassEnum.AGLue.getStateFlag().intValue());
                   TMaterialFormula glueBMaterial = t.getGlueBMaterial();
                   glueBMaterial.setMaterialClass(MaterialClassEnum.BGLue.getStateFlag().intValue());
                   if(diffusionPowderMaterial != null){
                       diffusionPowderMaterial.setMaterialClass(MaterialClassEnum.diffusionPowderMaterial.getStateFlag().intValue());
                       temp.add(diffusionPowderMaterial);
                   }else {
                       antiStarchMaterial.setMaterialClass(MaterialClassEnum.antiStarchMaterial.getStateFlag().intValue());
                       temp.add(antiStarchMaterial);
                   }
                   tPhosphors.forEach( o -> {
                       o.setMaterialClass(MaterialClassEnum.TPhosphors.getStateFlag().intValue());
                   });
                   temp.add(glueAMaterial);
                   temp.add(glueBMaterial);
                   temp.addAll(tPhosphors);

                   List<BsTaskFormulaDtl>  bsTaskFormulaDtlListTemp = temp.parallelStream().map(o -> {
                       BsTaskFormulaDtl bsTaskFormulaDtl = new BsTaskFormulaDtl();
                       bsTaskFormulaDtl.setMaterialId(o.getMaterialId());
                       bsTaskFormulaDtl.setTaskFormulaId(bsTaskFormula.getId());
                       bsTaskFormulaDtl.setMaterialClass(o.getMaterialClass().byteValue());
                       bsTaskFormulaDtl.setRatio(o.getRatio());
                       return bsTaskFormulaDtl;} ).collect(toList());
                     //新增配比详情表
                     bsTaskFormulaDtlDao.batchInsert(bsTaskFormulaDtlListTemp);

               });


           }
        if(! oldTaskDfId.equals(TaskEnum.TaskBatchProduction.getStateFlag()) && !oldTaskDfId.equals(TaskEnum.TaskBatchProductionValveNG.getStateFlag()) ){
          //复制阀体
          taskEeqptValveCopy(olderTaskStateId,newTaskStateId,EqptValveStateEnum.NOProduction.getStateFlag());
          //复制阀体对应的点胶设定参数
          copyTaskEqptGlueDosage(olderTaskStateId,newTaskStateId);
          log.info("当前方法的为  {编辑工单的配方}   {editTaskAIModel} === end");
        }

        return ResultUtils.success();
    }




    /**
     * 新建生产搭配
     * @param record
     * @return
     */
    @Transactional
    public Long addTAiModel(TAiModel record) throws QuException{
        //获取芯片波段数据
        List<Long> newchipRankIdList=record.getTChipWlRankList();
        TBom bom = record.getTBoms().get(0);

        //获取可能相同的芯片波段的数据
        List<Long> oldmodeIdList = this.tAiModelMapper.findAiModelIdList(record.getTypeMachineId(),record.getOutputRequireMachineId(),bom.getId());

        for (Long modelId:
                oldmodeIdList) {
            //获取它的芯片波段集合再进行比较
            List<Long> oldchipRankIdList = this.tAiModelMapper.findAiModelBomchipRankIdList(modelId);
            if(ListUtil.isListEqual(newchipRankIdList,oldchipRankIdList)){
                throw new QuException(1,"生产搭配创建重复");
            }
        }

        //先新增t_ai_model
        this.tAiModelMapper.insertSelective(record);

        TModelBom tModelBom = new TModelBom();
        tModelBom.setBomId(bom.getId());
        tModelBom.setModelId(record.getId());
        //再新增t_model_bom
        tAiModelMapper.insertTModelBom(tModelBom);
        Long modelBomId = tModelBom.getId();
        //新增其对应的芯片波段
        tModelBomChipWlRankDao.insert(newchipRankIdList,modelBomId);

       return record.getId();
    }





    /**
     * 推荐点胶设定参数（和过滤规则相关）
     * 若机台+阀体+机种历史量产过，则复用机台+阀体+机种历史点胶机设定值；
     * 若机台+阀体+机种历史未量产过，则复用机台+机种历史点胶机设定值;
     * 若机台+机种历史未量产过，客户输入点胶机设定值。
     * @
     */
    @Override
    public Result recommendGlueDosageMethod(Long eqptValveId,Long taskStateId){
        Double recommendGlueDosage = null;
        //获取当前的工单状态数据
        //BsTaskState bsTaskState = this.bsTaskStateDao.getActiveTaskStateAllInfo(taskId);
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);
        //模型ID
        Long oldModelId = taskStateForDatabase.getModelId();
        //模型详情
        BsAIModelDtl oldbsAIModelDtl = this.tAiModelMapper.findAiModelDtlByModelId(oldModelId);
        //机种ID
        Long typeMathcineId = oldbsAIModelDtl.getTypeMachineId();
        //机台id
        Long eqptId = this.bsEqptValveStateDao.getEqptIdByEqptValve(eqptValveId);
        //推荐 1通过 机台+阀体+机种
        List<Double> list = this.bsEqptValveStateDao.eqptValveDosgeRecommend(eqptValveId,typeMathcineId,FILE_STATEOK,null);
        if(list.size()>0){
            return ResultUtils.success(list.get(0));
        }else{
            list = this.bsEqptValveStateDao.eqptValveDosgeRecommend(null,typeMathcineId,FILE_STATEOK,eqptId);
        }
        if(list.size()>0){
            return ResultUtils.success(list.get(0));
        }
        return ResultUtils.success();
    }


    /**
     * 进入量产
     * @param taskId 工单ID
     * @param taskStateId 工单状态ID
     * @param userId 用户ID
     * @return
     */
    @Override
    @Transactional
    public Result  goToLC(Long taskId, Long taskStateId, Long userId){
        log.info("当前方法的为  {进入量产}   {goToLC}");
        log.info("当前的工单taskId：{}", taskId);
        log.info("当前的工单状态ID-TaskStateId：{}", taskStateId);
        log.info("用户Id{userId}：{}" ,userId);
        Long newTaskDfId = TaskEnum.TaskBatchProduction.getStateFlag();
        Long olderTaskStateId = taskStateId;
        Long newTaskStateId = null;

        //获取当前的工单状态数据
        //BsTaskState bsTaskState = this.bsTaskStateDao.getActiveTaskStateAllInfo(taskId);
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);
        String fileList = taskStateForDatabase.getFileidList();
        log.info("当前工单ID taskId:{} ",taskId);
        log.info("当前工单taskStateId:{} ",olderTaskStateId);
        log.info("当前工单状态：{} ",TaskEnum.stateFlagOf(taskStateForDatabase.getTaskDfId()).getStateName());
        log.info("当前用户ID：{} ",userId);
        //工单状态ID
      /*  bsTaskState.setCheckUser(userId);
        bsTaskState.setUpdateUser(userId);
        bsTaskState.setIsActive(false);
        //2.修改之前的状态
        this.bsTaskStateDao.updateBsTaskStatesById(bsTaskState);
        //1.新增状态
        bsTaskState.setIsActive(true);
        bsTaskState.setCreator(userId);
        bsTaskState.setTaskDfId(newTaskDfId);
        Integer num = 0;
        num = this.bsTaskStateDao.insertSelectiveNoWithFileIdList(bsTaskState);
        if(num == 0){
            throw new QuException(1,"重复调用");
        }
        newTaskStateId = bsTaskState.getId();*/
       bsTaskStateDao.updateTaskStateToNotActive(olderTaskStateId);
       taskStateForDatabase.setTaskDfId(newTaskDfId);
       taskStateForDatabase.setFileidList("");
       bsTaskStateDao.addTaskState(taskStateForDatabase);
       newTaskStateId = taskStateForDatabase.getId();
        //3.复制阀体
        taskEeqptValveProductCopy(olderTaskStateId,newTaskStateId);
        //4.复制配比
        taskFormulaCopy(olderTaskStateId,newTaskStateId);
        //5.复制点胶设定参数
        copyTaskEqptGlueDosage(olderTaskStateId,newTaskStateId);
        log.info("当前方法的为  {进入量产}   {goToLC} === end");
        //6.判定同步
        //return juageSynchronizationFormula(taskId,userId);
        return aiTaskFormulaForFile(fileList,userId);

    }

    private static  final Byte UserUpdateType = 0;
    private static  final Byte sysUpdateType = 1;
    private static  final Byte sysRecomedUpdateType = 2;
    private static  final Byte RecomedUpdateType = 3;


    private final  static  Integer OFF_LINE_RecommendRatio = 0;//离线推BOM
    private final  static  Integer ON_LINE_RecommendRatio = 1;//在线推BOM
    /**
     * 配比库中推荐配比，更新模型系数
     * 1.新增工单配比 和 数据库配比
     * 2.或者 新增数据库配比
     * 3.或者 修改数据库配比
     * @return
     * 生产过程中调用该接口，modeling_model_id=recommend_model_id;
     * 配比库中调用该接口，modeling_model_id为相似性模型的id。
     */
    @Override
    @Transactional
    public Result aiModelCustom(Long thisModelId,Long taskStateId,Long userId) throws QuException{
        // 需要推荐配比的模型ID
        //Long recommendModelId = null;
        //recommendModelId= thisModelId;

        //此时为相似性模型的ID
        //Long modelingModelId = selectModelId;


        /*MLSAiInterface mlsAiInterface = new MLSAiInterface();
        //新建时----配比库中模型建立接口
        AiResut aiResut = mlsAiInterface.customModelBuildMethod(selectTaskId,selectModelId);
        if(aiResut.getCode()!=0){
            return ResultUtils.error(1, "算法推荐配比失败");
        }
        //算法推荐模型接口
        Result<Map<Long,Double>> mapResult =mlsAiInterface.modelRecommendMethod(recommendModelId,0l,modelingModelId);
        if(mapResult.getCode()!=0){
            return ResultUtils.error(1,mapResult.getMessage());
        }
        Map<Long,Double> map = mapResult.getData();*/

        //String strResult = MLSAiInterface.recommendRatio(new Long(modelingModelId).intValue(),new Long(selectTaskId).intValue(), new Long(thisModelId).intValue(),OFF_LINE_RecommendRatio,0);
        //离线推BOM没有显色指数要求
        String strResult = MLSAiInterface.recommendRatio(thisModelId.intValue(),0,OFF_LINE_RecommendRatio,0);
        JSONObject jsonObject = JSON.parseObject(strResult);
        Integer code = jsonObject.getInteger("code");
        if(code != 0){
            return ResultUtils.error(1, jsonObject.getString("msg"));
        }
        JSONObject map = jsonObject.getJSONObject("data");


        //对应配比库中的配比的新增和修改
        EditTModelFormulaForPage editTModelFormulaForPage = new EditTModelFormulaForPage();
        /*//配比库中新增配比
        tAiModelService.addModelFormula(editTModelFormulaForPage);*/
        BsFormulaUpdateLog bsFormulaUpdateLog = new BsFormulaUpdateLog();
        bsFormulaUpdateLog.setUpdateType(sysRecomedUpdateType);
        bsFormulaUpdateLog.setCreator(userId);
        List<TModelFormulaForTables> tModelFormulaForTablesArrayList = new ArrayList<>();


        //通过模型从配比库中获取信息
        Result<TAIModelDtl> taiModelDtlResult = getOneMoldeByModelId(thisModelId);
        TAIModelDtl taiModelDtl = taiModelDtlResult.getData();
        //list是对应双层的情况
        List<TModelFormula> tModelFormulas = taiModelDtl.getTModelFormulas();

        Long bomId = null;
        for (TModelFormula t1:
        tModelFormulas) {
            bsFormulaUpdateLog.setModelBomId(t1.getModelBomId());
            List<TMaterialFormula> tPhosphorsMaterialFormulas = tAiModelMapper.selectPhosphorByBomIdReturn(t1.getBomId());
            if(tPhosphorsMaterialFormulas != null && tPhosphorsMaterialFormulas.size() >0 ){
                for (TMaterialFormula t2:
                        tPhosphorsMaterialFormulas) {
                    String  materialIdD = t2.getMaterialId()+".0";
                    //必须是荧光粉类型的
                    if(null != map.get(materialIdD)){
                        Object object = map.get(materialIdD);
                        Double ratio = Double.parseDouble(String.valueOf(object));
                        t2.setRatio(ratio);
                    }
                    TModelFormulaForTables tp = new TModelFormulaForTables();
                    tp.setModelBomId(t1.getModelBomId());
                    tp.setMaterialId(t2.getMaterialId());
                    tp.setMaterialClass(MaterialClassEnum.TPhosphors.getStateFlag());
                    tp.setRatio(t2.getRatio());
                    tModelFormulaForTablesArrayList.add(tp);
                }
            }
            //A胶
            Double glueARatio = this.bsTaskStateDao.getGlueARatio(t1.getGlueAMaterial().getMaterialId());

            TModelFormulaForTables tGlueAModelFormulaForTables = new TModelFormulaForTables();
            tGlueAModelFormulaForTables.setMaterialClass(MaterialClassEnum.AGLue.getStateFlag());
            tGlueAModelFormulaForTables.setMaterialId(t1.getGlueAMaterial().getMaterialId());
            tGlueAModelFormulaForTables.setModelBomId(t1.getModelBomId());
            tGlueAModelFormulaForTables.setRatio(glueARatio);
            tModelFormulaForTablesArrayList.add(tGlueAModelFormulaForTables);


            //B胶
            Double glueBRatio = this.bsTaskStateDao.getGlueBRatio(t1.getGlueBMaterial().getMaterialId());

            TModelFormulaForTables tGlueBModelFormulaForTables = new TModelFormulaForTables();
            tGlueBModelFormulaForTables.setMaterialClass(MaterialClassEnum.BGLue.getStateFlag());
            tGlueBModelFormulaForTables.setMaterialId(t1.getGlueBMaterial().getMaterialId());
            tGlueBModelFormulaForTables.setModelBomId(t1.getModelBomId());
            tGlueBModelFormulaForTables.setRatio(glueBRatio);
            tModelFormulaForTablesArrayList.add(tGlueBModelFormulaForTables);

            //抗沉淀粉
            if(t1.getAntiStarchMaterial() != null){

                TMaterialFormula tAntiStarchMaterialold = t1.getAntiStarchMaterial();

                Double antiStarchMaterialRatio = this.bsTaskStateDao.antiStarchMaterialRatio(tAntiStarchMaterialold.getMaterialId());
                antiStarchMaterialRatio = (glueARatio + glueBRatio) * antiStarchMaterialRatio;

                TModelFormulaForTables tAntiStarchMaterial = new TModelFormulaForTables();
                tAntiStarchMaterial.setMaterialClass(MaterialClassEnum.antiStarchMaterial.getStateFlag());
                tAntiStarchMaterial.setMaterialId(tAntiStarchMaterialold.getMaterialId());
                tAntiStarchMaterial.setModelBomId(t1.getModelBomId());
                tAntiStarchMaterial.setRatio(antiStarchMaterialRatio);
                tModelFormulaForTablesArrayList.add(tAntiStarchMaterial);
            //扩散粉
            }else if(t1.getDiffusionPowderMaterial() != null){

                Double diffusionPowderRaito = this.bsTaskStateDao.diffusionPowderRaito(t1.getDiffusionPowderMaterial().getMaterialId());
                diffusionPowderRaito = (glueARatio + glueBRatio) * diffusionPowderRaito;

                TModelFormulaForTables tdiffusionPowderMaterial = new TModelFormulaForTables();
                tdiffusionPowderMaterial.setMaterialClass(MaterialClassEnum.diffusionPowderMaterial.getStateFlag());
                tdiffusionPowderMaterial.setMaterialId(t1.getDiffusionPowderMaterial().getMaterialId());
                tdiffusionPowderMaterial.setModelBomId(t1.getModelBomId());
                tdiffusionPowderMaterial.setRatio(diffusionPowderRaito);
                tModelFormulaForTablesArrayList.add(tdiffusionPowderMaterial);
            }
            bomId = t1.getBomId();

            //
        }
        //是否有配比
        Integer isFormula = this.tAiModelMapper.findExitFormulaByModelId(thisModelId);

        editTModelFormulaForPage.setTModelFormulaForTables(tModelFormulaForTablesArrayList);
        editTModelFormulaForPage.setBsFormulaUpdateLog(bsFormulaUpdateLog);
        bsFormulaUpdateLog.setUpdateType(FormulaUpdateClassEnum.SysRecommend.getStateFlag());
        //如果没有则配比库新增
        if(isFormula == 0){
            this.tAiModelService.addModelFormula(editTModelFormulaForPage);
        //如果有则配比库修改-
            // （按说这种情况应该不存在的 多余的判断）
        //}else if(isFormula > 1){
        }else if(isFormula > 0){
            this.tAiModelService.updateModelFormula(editTModelFormulaForPage);
        }
        //验证时否有工单ID
        if(taskStateId != null){

            //获取当前的工单状态数据
            //BsTaskState bsTaskState = this.bsTaskStateDao.getActiveTaskStateAllInfo(thisTaskId);
            //Long taskStateId = bsTaskState.getId();
            TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);
            //2020-06-01 新增配比的维护
            bsTaskStateDao.updateTaskRatioInfo(taskStateId,0,userId,RatioSourceEnum.SYSTEM_RECOMMED.getFlag());

            //新增工单配比
            BsTaskFormulaForPage bsTaskFormulaForPage = new BsTaskFormulaForPage();
            bsTaskFormulaForPage.setTaskStateId(taskStateId);
            bsTaskFormulaForPage.setBomId(bomId);
            //bsTaskFormulaForPage.setTaskId(thisTaskId);
            bsTaskFormulaForPage.setTaskId(taskStateForDatabase.getTaskId());
            List<BsTaskFormulaDtl> bsTaskFormulaDtlList = new ArrayList<>();

            for (TModelFormulaForTables t:
            tModelFormulaForTablesArrayList) {
                BsTaskFormulaDtl bsTaskFormulaDtl = new BsTaskFormulaDtl();
                bsTaskFormulaDtl.setRatio(t.getRatio());
                bsTaskFormulaDtl.setMaterialId(t.getMaterialId());
                bsTaskFormulaDtl.setMaterialClass(t.getMaterialClass());
                bsTaskFormulaDtlList.add(bsTaskFormulaDtl);
            }
            bsTaskFormulaForPage.setBsTaskFormulaDtlList(bsTaskFormulaDtlList);
            //工单中修改对应的配比
            if(isFormula == 0){
                //如果没有则配比库新增
                //工单中新建对应的配比
                addTaskFormula(bsTaskFormulaForPage);
            }else if(isFormula > 0){
                updateTaskFormula(bsTaskFormulaForPage);
            }

        }
        Result result = new Result();
        result.setCode(code);
        /*result.setMessage(aiResut.getMsg());*/
        result.setData(map);
        return result;
    }







    /**
     * 推模型数据列表-model列表
     * 新模型的model_id
     * @param modelId
     * @param typeMachineSpec
     * @param tOutputCode
     * @param bomCode
     * @return
     */
    @Override
    public Result aiRecommendModelList(Long modelId,
                                       String typeMachineSpec,
                                       String tOutputCode,
                                       String bomCode,
                                       Integer pageNum,
                                       Integer pageSize){
        MLSAiInterface mlsAiInterface = new MLSAiInterface();
        Result<List<AiModelFilter>> listResult = mlsAiInterface.modelModelFilterMethod(modelId);
        if(listResult.getCode()!=0){
            return ResultUtils.error(1,listResult.getMessage());
        }
        List<AiModelFilter> aiModelFilterList = listResult.getData();
        List<Long> modelIdList = new ArrayList<>();
        for (AiModelFilter t:
             aiModelFilterList) {
            modelIdList.add(t.getModel_id());
        }

        PageHelper.startPage(pageNum,pageSize);
        //模型推荐列表
        List<AiRecommendModelListPage> aiRecommendModelListPages =
                this.bsTaskStateDao.findModelRecommendList(modelIdList,typeMachineSpec,tOutputCode,bomCode);
        PageInfo pageInfo = new PageInfo(aiRecommendModelListPages);
        List<AiRecommendModelListPage> aiRecommendModelListPageList = pageInfo.getList();
        Integer maxLeagth = 0;
        for (AiRecommendModelListPage t:
        aiRecommendModelListPageList) {
            Integer length =t.getTBom().getTPhosphors().size();
            if(maxLeagth < length){
                maxLeagth = length;
            }
            Map<String,String>   outputRequireParams= tOutputRequirementsDao.getOutputRequitementParams(t.getOutputRequireMachineId());
            t.setOutputRequireParams(outputRequireParams);
        }
        if(aiRecommendModelListPageList.size()>0){
            aiRecommendModelListPageList.get(0).setMaxLength(maxLeagth);
        }
        return ResultUtils.success(pageInfo);
    }



    /**
     * 推模型列表-工单列表
     * @param taskCode
     * @param groupId
     * @param taskType
     * @param modelId
     * @param pageNum
     * @param pageSize
     * @return
     */
    @Override
    public Result findAiRecommendTaskList(String taskCode,
                                          Long groupId,
                                          Byte taskType,
                                          Long modelId,
                                          Integer pageNum,
                                          Integer pageSize){
        PageHelper.startPage(pageNum,pageSize);
        List<AiRecommendTaskListPage> aiRecommendTaskListPageList =
                this.bsTaskStateDao.findAiRecommendTaskList(taskCode, groupId, taskType, modelId);
        PageInfo pageInfo = new PageInfo(aiRecommendTaskListPageList);
        return ResultUtils.success(pageInfo);
    }





   /**
     * 模型修正接口
     * 1.调用数据配比建立模型
     * 2.建立成功- 调用推荐配比接口
    * recommend_model_id 需要推荐配比的模型ID
    * 生产过程中调用该接口，modeling_model_id=recommend_model_id;
    * 配比库中调用该接口，modeling_model_id为相似性模型的id。
     * @return
     */
     @Transactional
     @Override
     public  Result aiUpdateModel(Long taskId, Long taskStateId, Long userId,Integer raRequire){
         log.info("当前方法的为  {模型修正接口}   {aiUpdateModel}");
         log.info("当前的工单taskId：{}", taskId);
         log.info("当前的工单状态ID-TaskStateId：{}", taskStateId);
         log.info("用户Id{userId}：{}" ,userId);
         Long olderTaskStateId = taskStateId;
         Long newTaskStateId = null;
         Long newTaskDfId = TaskEnum.TaskPendingSample.getStateFlag();
         /*Long recommendModelId = null;
         Long modelingModelId = null;
         Long withFiletaskStateId = null;*/


       /*  //获取当前的工单状态数据
         BsTaskState bsTaskState = this.bsTaskStateDao.getActiveTaskStateAllInfo(taskId);
         //获取有分光文件的taskStateId
         withFiletaskStateId = this.bsTaskStateDao.getThisTaskLastWithFile_TaskStateId(taskId);*/
         TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);
         Long oldTaskDfId = taskStateForDatabase.getTaskDfId();
         Long modelId = taskStateForDatabase.getModelId();

         /*if(!raRequire.equals(-1)){
             //更改RaR9要求
             this.bsTaskStateDao.updateBsTaskRaR9Require(taskId,raRequire);
         }*/
         //Long modelId = bsTaskState.getModelId();

         //String strResult = MLSAiInterface.recommendRatio(0,new Long(taskId).intValue(),new Long (modelId).intValue(),ON_LINE_RecommendRatio,raRequire);
         String strResult = MLSAiInterface.recommendRatio(modelId.intValue(),taskStateId.intValue(),ON_LINE_RecommendRatio,raRequire);
         JSONObject jsonObject = JSON.parseObject(strResult);
         Integer code = jsonObject.getInteger("code");
         String message = jsonObject.getString("msg");

       /*  MLSAiInterface mlsAiInterface = new MLSAiInterface();
         //配比库中模型生产过程中建立接口
         AiResut aiResut = mlsAiInterface.prductModelBuildMethod(withFiletaskStateId,modelId);
         recommendModelId = bsTaskState.getModelId();
         modelingModelId = bsTaskState.getModelId();*/
         //配比库中模型建立接口 -- 建立成功
         if(code == 0){
//             //Result<Map<Long,Double>> mapResult =mlsAiInterface.modelRecommendMethod(recommendModelId,taskStateId,modelingModelId);
//             if(mapResult.getCode()!=0){
//                return ResultUtils.error(1,mapResult.getMessage());
//             }
//             Map<Long,Double> map = mapResult.getData();

             Map<Long,Double> map =(Map<Long,Double>)jsonObject.get("data");

             /*olderTaskStateId = bsTaskState.getId();
             bsTaskState.setCheckUser(userId);
             bsTaskState.setUpdateUser(userId);
             // 设置变更原因为 ----- 修改配比
             bsTaskState.setSolutionType((byte)3);
             bsTaskState.setIsActive(false);
             //2.修改之前的状态
             this.bsTaskStateDao.updateBsTaskStatesById(bsTaskState);
             //3.新增状态
             bsTaskState.setIsActive(true);
             bsTaskState.setCreator(userId);
             bsTaskState.setIsRetest(false);
             bsTaskState.setTaskDfId(newTaskDfId);
             Integer num = 0;
             num = this.bsTaskStateDao.insertSelectiveNoWithFileIdList(bsTaskState);
             if(num == 0){
                 new QuException(1,"重复调用");
             }
             newTaskStateId = bsTaskState.getId();*/
            bsTaskStateDao.updateTaskStateToNotActive(olderTaskStateId);
            Integer ratioVersion = taskStateForDatabase.getRatioVersion();
            if(ratioVersion == null){
                ratioVersion = 0;
            }else {
                ratioVersion ++;
            }
            taskStateForDatabase.setRatioVersion(ratioVersion);
            taskStateForDatabase.setRatioCreateTime(Convert.getNow());
            taskStateForDatabase.setRatioCreator(userId);
            taskStateForDatabase.setRatioSource(RatioSourceEnum.SYSTEM_RECOMMED.getFlag());
            taskStateForDatabase.setTaskDfId(newTaskDfId);
            taskStateForDatabase.setFileidList("");
            bsTaskStateDao.addTaskState(taskStateForDatabase);
            newTaskStateId = taskStateForDatabase.getId();
             //删除工单对阀体的热表
             this.bsTaskStateDao.deleteBsEqptTaskRuntimeByTaskId(taskId);
             log.info("当前方法的为  {模型修正接口}   {aiUpdateModel} === end");

             if(!oldTaskDfId.equals(TaskEnum.TaskBatchProduction.getStateFlag()) && !oldTaskDfId.equals(TaskEnum.TaskBatchProductionValveNG.getStateFlag())){
                 //复制阀体
                 taskEeqptValveCopy(olderTaskStateId,newTaskStateId,EqptValveStateEnum.NOProduction.getStateFlag());
                 //复制阀体对应的点胶设定参数
                 copyTaskEqptGlueDosage(olderTaskStateId,newTaskStateId);
             }
             //复制和新增配比 并且 按系统推荐修改点胶量
             return  taskFormulaCopyAndUpdate(olderTaskStateId,newTaskStateId,map);
         }else{
             log.info("当前方法的为  {模型修正接口}   {aiUpdateModel} === end");
            return  ResultUtils.error(1,message);
         }
     }


    /**
     * 复制配比并修改
     * @param olderTaskStateId
     * @param newTaskStateId
     */
    @Transactional
    public Result taskFormulaCopyAndUpdate(Long olderTaskStateId,Long newTaskStateId,Map<Long,Double> map){
        log.info("当前方法的为  {复制配比并修改}   {taskFormulaCopyAndUpdate} ==> 开始");
        log.info("olderTaskStateId :{}",olderTaskStateId);
        log.info("newTaskStateId :{}",newTaskStateId);
        log.info("系统推荐出的配比：map ：{}",map);
        if(olderTaskStateId == null || newTaskStateId == null){
            return ResultUtils.error(1,"新旧工单状态异常");
        }
        if(olderTaskStateId >= newTaskStateId){
            return ResultUtils.error(1,"新旧工单状态异常");
        }
        //获取之前的工单状态和BOM关系表数据
        List<BsTaskFormulaMix>  bsTaskFormulaList = this.bsTaskFormulaDao.getBsTaskFormulaMix(olderTaskStateId);

        List<BsTaskFormulaDtl> bsTaskFormulaDtlList = new ArrayList<>();
        //银光粉
        Byte TPhosphosrUpdateClassType = MaterialClassEnum.TPhosphors.getStateFlag();
        //扩散粉
        Byte diffusionPowderMaterial = MaterialClassEnum.diffusionPowderMaterial.getStateFlag();
        //坑沉淀粉
        Byte antiStarchMaterial = MaterialClassEnum.antiStarchMaterial.getStateFlag();
        //A胶
        Byte AGLueType = MaterialClassEnum.AGLue.getStateFlag();
        //B胶
        Byte BGlueType = MaterialClassEnum.BGLue.getStateFlag();
        for (BsTaskFormulaMix t:
                bsTaskFormulaList) {
            BsTaskFormula bsTaskFormula = new BsTaskFormula();
            bsTaskFormula.setTaskBomId(t.getTaskBomId());
            bsTaskFormula.setTaskStateId(newTaskStateId);
            this.bsTaskFormulaDao.insertSelective(bsTaskFormula);
            Long newBsTaskFormulaDtl = bsTaskFormula.getId();



            Double aGlueRatio = null;//原材料库中a胶的配比
            Double bGlueRatio = null;//原材料库中b胶的配比
            Double diffusionPowderRaito = null;//原材料库中扩散粉的配比
            Double antiStarchMaterialRatio = null;//原材料库中抗沉淀粉的配比


            for(BsTaskFormulaDtl t2: t.getBsTaskFormulaDtlList()) {


                t2.setTaskFormulaId(newBsTaskFormulaDtl);
                Long   materialId = t2.getMaterialId();
                String  strMaterialIdD = t2.getMaterialId()+".0";
                Byte materialClass = t2.getMaterialClass();

                if(materialClass.equals(AGLueType)){
                    aGlueRatio = this.bsTaskStateDao.getGlueARatio(materialId);
                }
                else if(materialClass.equals(BGlueType)){
                    bGlueRatio = this.bsTaskStateDao.getGlueBRatio(materialId);
                }
                else if(materialClass.equals(diffusionPowderMaterial)){
                    diffusionPowderRaito = this.bsTaskStateDao.diffusionPowderRaito(materialId);
                }
                else if(materialClass.equals(antiStarchMaterial)){
                    antiStarchMaterialRatio = this.bsTaskStateDao.antiStarchMaterialRatio(materialId);
                }

                //必须是荧光粉类型的
                if(materialClass.equals(TPhosphosrUpdateClassType) && null != map.get(strMaterialIdD)){
                  Object object = map.get(strMaterialIdD);
                  Double ratio = Double.parseDouble(String.valueOf(object));
                  t2.setRatio(ratio);
                }



            }

            for(BsTaskFormulaDtl t2: t.getBsTaskFormulaDtlList()) {
                Long   materialId = t2.getMaterialId();
                Byte materialClass = t2.getMaterialClass();
                if(materialClass.equals(AGLueType)){
                    t2.setRatio(aGlueRatio);
                }
                else if(materialClass.equals(BGlueType)){
                    t2.setRatio(bGlueRatio);
                }
                else if(materialClass.equals(diffusionPowderMaterial)){
                    Double ratio = (aGlueRatio + bGlueRatio) * diffusionPowderRaito;
                    t2.setRatio(ratio);
                }
                else if(materialClass.equals(antiStarchMaterial)){
                    Double ratio = (aGlueRatio + bGlueRatio) * antiStarchMaterialRatio;
                    t2.setRatio(ratio);
                }
                System.out.println("配比详情====>"+t2);
                bsTaskFormulaDtlDao.insert(t2);
            }
        }

        //this.bsTaskFormulaDtlDao.batchInsert(bsTaskFormulaDtlList);
        log.info("当前方法的为  {复制配比并修改}   {taskFormulaCopyAndUpdate} ==> 结束");
        return  ResultUtils.success();
    }



    /**
     * 1.试样品质NG-取消NG时调用
     * 2.前测OK后-品质测试OK
     * 3.进入量产时调用
     * --- 2020-05-26 修改
     *     -- taskId 改为 taskStateId
     *//*
    @Transactional
    public Result juageSynchronizationFormula(Long taskStateId,Long userId){
        //String fileList = this.bsTaskStateDao.getLastFileList(taskId);
        String   fileList =  bsTaskStateDao.getTaskStateFileList(taskStateId);
        Long fileId = this.bsTaskStateDao.getJudageSynchronizationFileId(fileList);
        return  aiTaskFormulaForFile(fileId,userId);
    }*/


    /**
     * 上传分光文件后判断是否需要调整配比 需要则调整
     * -- 2020-05-26 改动
     *       -- fileId - > fileList
     * @param fileId
     * @param fileList
     * @return
     */
    @Transactional
    public Result aiTaskFormulaForFile(String fileList,Long userId){
        Long fileId = this.bsTaskStateDao.getJudageSynchronizationFileId(fileList);
        EditTModelFormulaForPage editTModelFormulaForPage  = new EditTModelFormulaForPage();
        Integer num = this.bsTaskStateDao.findFileEuclidean_distance_xAndEuclidean_distance_y(fileId);
        if(num == null){
            return ResultUtils.success();
        }
        if(num > 0){
            List<TModelFormulaForTables> tModelFormulaForTablesList = this.bsTaskStateDao.findTaskFormulaByFileId(fileId);
            Long modelBomId = null;
            if(tModelFormulaForTablesList.size()>0){
                modelBomId =  tModelFormulaForTablesList.get(0).getModelBomId();
            }
            BsFormulaUpdateLog bsFormulaUpdateLog = new BsFormulaUpdateLog();
            bsFormulaUpdateLog.setModelBomId(modelBomId);
            //用户编辑
            bsFormulaUpdateLog.setUpdateType(FormulaUpdateClassEnum.UserEdit.getStateFlag());
            bsFormulaUpdateLog.setCreator(userId);

            editTModelFormulaForPage.setBsFormulaUpdateLog(bsFormulaUpdateLog);
            editTModelFormulaForPage.setTModelFormulaForTables(tModelFormulaForTablesList);

            return tAiModelService.updateModelFormula(editTModelFormulaForPage);
        }
        return ResultUtils.success();
    }


    /**
     * 配比库中获取该生产搭配对应的-工单生产列表
     * @param modelId
     * @return
     * -- 2020-05-28 修改
     *    -- 只限主流程的工单
     */
    @Override
    public Result findTaskListByTypeModelId(Long modelId){
        List<BsTaskList> bsTaskLists =  this.bsTaskStateDao.findTaskListByTypeModelId(modelId);
        return ResultUtils.success(bsTaskLists);
    }


    @Override
    public Result checkoutAiModel(Long taskStateId) {
        //获取当前的工单状态数据
        //BsTaskState bsTaskState = this.bsTaskStateDao.getActiveTaskStateAllInfo(taskId);
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);
        //Long modelId = bsTaskState.getModelId();
        Long modelId = taskStateForDatabase.getModelId();
        String str = this.tAiModelService.checkoutAiModel(modelId);
       /* if(b){
            return ResultUtils.success();
        }*/
        return ResultUtils.error(0,str);
    }


    /**
     * 系统推荐
     * @param taskId
     * @return
     */
    @Override
    public Result systemAdvice(Long taskStateId) {
        Map<Integer,String> data = new HashMap<>();
        //String result = MLSAiInterface.ngProposeJudge(taskId.intValue());
        String result = MLSAiInterface.ngProposeJudge(taskStateId.intValue());
        String strData = JSON.parseObject(result).getString("data");
        String message = JSON.parseObject(result).getString("msg");
        if(strData == null || "".equals(strData)){
            return ResultUtils.error(-1,message);
        }
        String[] strings =  strData.split(",");
        List<String> stringList = Arrays.asList(strings);
        List<Integer> integerList = stringList.stream().map(s -> Integer.parseInt(s)).sorted().collect(toList());
       /* BsTaskState bsTaskState = bsTaskStateDao.getActiveTaskStateAllInfo(taskId);
        Long modelId = bsTaskState.getModelId();*/
       TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);
       Long modelId = taskStateForDatabase.getModelId();
       TargetParameter targetParameter = tAiModelMapper.getTypeMachineTargetParameterByModelId(modelId);
       Double r9 = targetParameter.getR9();


        integerList.stream().forEach(iteam ->{
            switch(iteam){
                case 1:
                    data.put(iteam,"增加芯片波长");
                    break;
                case 2:
                    data.put(iteam,"提高亮度，系统优化配方");
                    break;

                case 3:
                    data.put(iteam,"人为增加芯片有效发光面积");
                    break;
                case 4:
                    data.put(iteam,"人为减小芯片有效发光面积");
                    break;
                case 5:
                    data.put(iteam,"考虑色坐标，系统优化配比");
                    break;
                case 6:
                    if(r9 == null){
                        data.put(iteam,"考虑Ra，系统优化配方");
                    }else {
                        data.put(iteam,"考虑Ra/R9，系统优化配方");
                    }
                    break;
                case 7:
                    if(r9 == null){
                        data.put(iteam,"考虑Ra，系统优化配比");
                    }else {
                        data.put(iteam,"考虑Ra/R9，系统优化配比");
                    }
                    break;
                case 8:
                    if(r9 == null){
                        data.put(iteam,"忽略Ra、考虑色坐标，系统优化配比");
                    }else {
                        data.put(iteam,"忽略Ra/R9、考虑色坐标，系统优化配比");
                    }
                    break;

            }
        });

        return ResultUtils.success(data);
    }


    @Override
    public Result getjudgementType(Long taskStateId) {
        /*BsTaskState bsTaskState = bsTaskStateDao.getActiveTaskStateAllInfo(taskId);
        Long modelId = bsTaskState.getModelId();*/
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);
        Long modelId = taskStateForDatabase.getModelId();
        TargetParameter targetParameter = tAiModelMapper.getTypeMachineTargetParameterByModelId(modelId);
        Double r9Value = targetParameter.getR9();
        Double raValue = targetParameter.getRaTarget();
        Map<String,Object> map = new HashMap<>();
        if(raValue == null){
            map.put("ra",0);
            map.put("r9",0);
        }else {
            map.put("ra",1);
            if(r9Value == null){
                map.put("r9",0);
            }else {
                map.put("r9",1);
            }
        }
        map.put("ColorCoordinates",1);
        map.put("lm",1);
        return ResultUtils.success(map);
    }



    @Override
    public Result getCloseMainProcessTask(String taskCode,
                                          Byte type,
                                          Long groupId,
                                          String typeMachineSpec,
                                          Byte stateFlag,
                                          Integer pageNum,
                                          Integer pageSize){
        PageHelper.startPage(pageNum,pageSize);
        List<TaskMainProcessClose> taskMainProcessCloseList = bsTaskStateDao.getCloseMainProcessTask(taskCode, groupId, typeMachineSpec, type);
        PageInfo pageInfo = new PageInfo(taskMainProcessCloseList);
        return ResultUtils.success(pageInfo);
    }

    @Override
    public Result getNewestTaskStateId(Integer processType, Integer processVersion, Long taskId) {
        Long taskStateId = bsTaskStateDao.getNewestTaskStateId(processType,processVersion,taskId);
        return ResultUtils.success(taskStateId);
    }

    @Override
    public Result getFilterBOMList(FilterBOMDataForPage filterBOMDataForPage) {
        TBomListPage tBomListPage = new TBomListPage();
        Long taskStateId = filterBOMDataForPage.getTaskStateId();
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);
        List<ChipIdAndNum> chiplist = filterBOMDataForPage.getChipIdAndNumList();

        Map<Long,List<ChipIdAndNum>> mapChipList =  chiplist.stream().collect(Collectors.groupingBy(ChipIdAndNum::getChipId));
        List<ChipIdAndNum> chiplist1 = new ArrayList<>();
        for(Long entryKey: mapChipList.keySet()){
            ChipIdAndNum chipIdAndNum = new ChipIdAndNum();
            chipIdAndNum.setChipId(entryKey);
            Integer chipNum = 0;
            List<ChipIdAndNum> entryValue = mapChipList.get(entryKey);

            for (ChipIdAndNum t:
            entryValue) {
                chipNum = chipNum + t.getChipNum();
            }
            chipIdAndNum.setChipNum(chipNum);
            chiplist1.add(chipIdAndNum);
        }
        Long modelId = taskStateForDatabase.getModelId();
        Long typeMachineId = bsTaskStateDao.getTypeMachineId(modelId);
        List<Long> bomList = bsTaskStateDao.getBomIdList(typeMachineId);

        List<Long> resultBomIdList = new ArrayList<>();
        for (Long t : bomList) {
            List<ChipIdAndNum> chiplist2 = bsTaskStateDao.getBomChipList(t);
            if(chiplist1.equals(chiplist2)){
                resultBomIdList.add(t);
            }
        }
        if(resultBomIdList.size() != 0){
            List<TBom> tBomList = bsTaskStateDao.getBomList(resultBomIdList);
            Integer maxPhosphorLength = 0;
            for (TBom tbom: tBomList
            ) {
                List<TPhosphor> tPhosphorList = tBomDao.selectPhosphorByBomId(tbom.getId());
                if(tPhosphorList.size() > maxPhosphorLength){
                    maxPhosphorLength = tPhosphorList.size();
                }
                tbom.setTPhosphors(tPhosphorList);
                tbom.setChipList(tBomDao.getChipList(tbom.getId()));
            }

            tBomListPage.setMaxLength(maxPhosphorLength);
            tBomListPage.setTBoms(tBomList);
        }else{
            tBomListPage.setMaxLength(0);
            tBomListPage.setTBoms(new ArrayList<>());
        }
        return ResultUtils.success(tBomListPage);
    }

    @Override
    public Result getjudagementTypeByFileId(Long fileId) {

        return ResultUtils.success(bsTaskStateDao.getjudagementTypeByFileId(fileId));
    }


    /**
     * 2020/9/5  保存更新配粉重量
     * @param zConsumption
     * @return
     */
    @Override
    @Transactional
    public Result saveMixPowderWeight(ZConsumption zConsumption) {

        //List<ZConsumption> zConsumptions = new ArrayList<>();
        //zConsumptions.add(zConsumption);
        Long taskId = zConsumption.getTaskId();
        //Long taskStateId = zConsumption.getTaskStateId();
        //查询得到该任务单是否有记录
        //Result powderWeight = getMixPowderWeight(taskId, taskStateId);
        //Object data = powderWeight.getData();
        ZConsumption zc = bsZConsumptionDao.getMixPowderWeightBYtIdAndtsId(taskId);
        //存在修改，不存在新增
        if(zc != null && !"".equals(zc)){
            bsZConsumptionDao.updateMixPowderWeight(zConsumption);
        }else{
             bsZConsumptionDao.saveMixPowderWeight(zConsumption);
        }


        return ResultUtils.success();
    }

    /**
     * 2020/9/5 查询配粉重量
     * @param
     * @return
     */
    @Override
    public Result getMixPowderWeight(Long taskId,Long taskStateId) {
        //saveMixPowderWeight();
        ZConsumption mixPowderWeight = new ZConsumption();
        mixPowderWeight.setGlueAMaterial(0.0);
        mixPowderWeight.setGlueBMaterial(0.0);
        mixPowderWeight.setAntiStarchMaterial(0.0);
        mixPowderWeight.setDiffusionPowderMaterial(0.0);
        mixPowderWeight.setTphosphors0(0.0);
        mixPowderWeight.setTphosphors1(0.0);
        mixPowderWeight.setTphosphors2(0.0);
        mixPowderWeight.setTphosphors3(0.0);
        mixPowderWeight.setTphosphors4(0.0);

        ZConsumption mixPowderWeightBYtIdAndtsId = bsZConsumptionDao.getMixPowderWeightBYtIdAndtsId(taskId);
        if(mixPowderWeightBYtIdAndtsId != null && !"".equals(mixPowderWeightBYtIdAndtsId)){
            return ResultUtils.success(mixPowderWeightBYtIdAndtsId);
        }
        return ResultUtils.success(mixPowderWeight);
    }

    public static Boolean compareList(List<ChipIdAndNum> list1,List<ChipIdAndNum> list2){
        if(list1.size() != list2.size()){
            return false;
        }
       List<ChipIdAndNum> resultList = list1.stream().map( o -> list2.stream().filter( t -> Objects.equals(o.getChipId(),t.getChipId()) && Objects.equals(o.getChipNum(),t.getChipNum()) ).findFirst().orElse(null))
                .filter(m -> m != null ).collect(toList());

        resultList.forEach(System.out::println);
        if(resultList.size() == list1.size()){
            return true;
        }
        return false;
    }

    /**
     * 开始推荐
     * @param startAdvice
     * @return
     */
    @Override
    public Result getSpAdvice(StartAdvice startAdvice){

        Long modelId = startAdvice.getModelId();
        Long taskStateId = startAdvice.getTaskStateId();
        Long raHOrL = startAdvice.getRaHOrL();
        Double raRatio = startAdvice.getRaRatio();
        Double wt = startAdvice.getWt();
        String points = startAdvice.getPoints();
        Result result = MLSAiInterface.dadianRatioMethod(modelId.intValue(), taskStateId.intValue(), raHOrL.intValue(), raRatio.floatValue(), wt.floatValue(), points);
        String strData = result.getData().toString();
        strData= strData.substring(1,strData.length()-2);

        List<AiDadainRatio> aiDadainRatios = new ArrayList<>();

        String[] allData = strData.split(",");
        for(int i = 0; i < allData.length ; i++){
            String[] specAndRatio = allData[i].split(":");
            AiDadainRatio aiDadainRatio = new AiDadainRatio();
            specAndRatio[0] = specAndRatio[0].substring(1,specAndRatio[0].length() -1);
            Double dd = Double.valueOf(specAndRatio[0]);
            long specId = new Double(dd).longValue();

            aiDadainRatio = tPhosphorDao.getPhSpec(specId);
            //aiDadainRatio.setSpec(phSpec);

            Double phRatio = Double.valueOf(specAndRatio[1]);
            if(startAdvice.getGlueAMaterial() != null && !"".equals(startAdvice.getGlueAMaterial())){
                phRatio = phRatio * startAdvice.getGlueAMaterial();
            }else{
                ResultUtils.error(1,"未接收到a胶");
            }

            BigDecimal b1 = new BigDecimal(phRatio);
            phRatio = b1.setScale(4, BigDecimal.ROUND_HALF_UP).doubleValue();
            aiDadainRatio.setRatio(phRatio);
            aiDadainRatios.add(aiDadainRatio);
        }
/*
        List<String> specTph = new ArrayList<>();
        List<Double> ratioTph = new ArrayList<>();
        List<List> resultData = new ArrayList<>();
        for (AiDadainRatio aida :AiDadainRatios) {
            specTph.add(aida.getSpec());
            ratioTph.add(aida.getTphRatio());
        }
        resultData.add(specTph);
        resultData.add(ratioTph);

        result.setData(resultData);
        //tBom.setTPhosphors();
*/
        Collections.sort(aiDadainRatios);
        result.setData(aiDadainRatios);
        return result;
    }

    /**
     *
     * @param strfileIdList
     * @param eqptValveId
     * @param judgementResult 判定结果，按照色坐标，亮度，Ra,R9的顺序传
     *                        0 :0k 1:NG,中间用逗号分隔
     */
    private void recordJudgementResult(String strfileIdList,
                                        Long eqptValveId,
                                        String judgementResult){
        String[] resultArray = judgementResult.split(",");
        int length = resultArray.length;
        String resultColorCoordinates = resultArray[0];
        String resultLightness = resultArray[1];
        String resultRa = null;
        String resultR9 = null;
        if(length >= 3){
            resultRa = resultArray[2];
            if(length == 4){
                resultR9 = resultArray[3];
            }
        }
        List<Long> filedIdList = this.bsTaskStateDao.selectNoJudegeAndNoDeleteFileIdList(strfileIdList, eqptValveId);
        filedIdList = filedIdList.parallelStream().distinct().collect(toList());
        for (Long o:
             filedIdList) {
            this.bsTaskStateDao.insetFileJudgementResult(o,resultColorCoordinates,resultLightness,resultRa,resultR9);
        }


    }


    public static void main(String[] args) {
      /*  Long oldTaskDfId = 7l;
        System.out.println(oldTaskDfId.equals(TaskEnum.TaskBatchProductionValveNG.getStateFlag()));*/
        //String result = MLSAiInterface.ngProposeJudge(new Long(taskId).intValue());
      /*  String result = "1,2,3,4";
        String[] strings =  result.split(",");
        List<String> stringList = Arrays.asList(strings);
        List<Integer> integerList = stringList.stream().map(s -> Integer.parseInt(s)).collect(toList());
        integerList.forEach(item -> System.out.println(item));*/
        List<ChipIdAndNum> list1 = new ArrayList<>();
        List<ChipIdAndNum> list2 = new ArrayList<>();
        ChipIdAndNum chipIdAndNum1 = new ChipIdAndNum(1l,2);
        ChipIdAndNum chipIdAndNum2 = new ChipIdAndNum(2l,1);
        ChipIdAndNum chipIdAndNum3 = new ChipIdAndNum(3l,1);
        ChipIdAndNum chipIdAndNum4 = new ChipIdAndNum(4l,4);
        ChipIdAndNum chipIdAndNum5 = new ChipIdAndNum(5l,5);

        list1.add(chipIdAndNum1);
        list1.add(chipIdAndNum2);
        list1.add(chipIdAndNum4);
        list1.add(chipIdAndNum3);

        list2.add(chipIdAndNum1);
        list2.add(chipIdAndNum2);
        list2.add(chipIdAndNum4);
        list2.add(chipIdAndNum5);
        System.out.println(compareList(list1,list2));
    }



}
