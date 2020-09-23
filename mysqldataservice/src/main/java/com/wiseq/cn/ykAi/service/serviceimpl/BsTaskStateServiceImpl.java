package com.wiseq.cn.ykAi.service.serviceimpl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.MaterialClassEnum;
import com.wiseq.cn.commons.enums.TaskEnum;
import com.wiseq.cn.commons.exception.QuException;
import com.wiseq.cn.commons.utils.Convert;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.dataCollection.FileTestResult;
import com.wiseq.cn.entity.ykAi.*;
import com.wiseq.cn.ykAi.dao.*;
import com.wiseq.cn.ykAi.service.BsTaskStateService;
import org.apache.ibatis.annotations.Param;
import org.apache.logging.log4j.util.Strings;
import org.apache.xmlbeans.impl.xb.xsdschema.Public;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.lang.reflect.Array;
import java.util.*;
import java.util.stream.Collectors;

import static java.util.stream.Collectors.toList;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/19     jiangbailing      原始版本
 * 文件说明:
 */
@Service
public class BsTaskStateServiceImpl implements BsTaskStateService {
    @Autowired
    private BsTaskStateDao bsTaskStateDao;
    @Autowired
    private BsFormulaUpdateLogDtlDao bsFormulaUpdateLogDtlDao;
    @Autowired
    private BsTaskRecordDao recordDao;


    /**
     * 获取工单状态
     * @param taskId
     * @param taskStateId
     * @return
     */
    @Override
   public Result getActiveTaskState(Long taskId,Long taskStateId){
        //TaskState taskStateInfo =  this.bsTaskStateDao.getActiveTaskState(taskId);
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);
        if(taskStateForDatabase == null ){
            return ResultUtils.error(1,"该工单不存在");
            //是不是活跃状态
        }if(!taskStateForDatabase.getIsActive().equals(1)){
            return ResultUtils.error(1,"该数据不是最新的活跃数据");
        }

        return ResultUtils.success();
    }

    @Override
    public Result getTaskIsIgnoreRaR9(Long taskStateId) {
        //BsTaskState bsTaskState = this.bsTaskStateDao.getActiveTaskStateAllInfo(taskId);
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);
        //Long modelId = bsTaskState.getModelId();
        Long modelId =  taskStateForDatabase.getModelId();
        BsFormulaTargetParameter bsFormulaTargetParameter = bsFormulaUpdateLogDtlDao.selectTypeMachineTargetParameterByModelId(modelId);

        Double raTarget = bsFormulaTargetParameter.getRaTarget();
        Double r9 = bsFormulaTargetParameter.getR9();
      /*  BsTaskTable  bsTaskTable = bsTaskStateDao.getBsTaskTableById(taskId);
        if(bsTaskTable.getRaR9Type().equals(0)){
            if(raTarget != null && r9 != null){
                return ResultUtils.success("默认当前配方Ra/R9为OK！");
            }else if(raTarget != null && r9 == null){
                return ResultUtils.success("默认当前配方Ra为OK！");
            }else{
                return ResultUtils.success("");
            }

        }*/
        if(taskStateForDatabase.getRar9Type().equals(0)){
            if(raTarget != null && r9 != null){
                return ResultUtils.success("默认当前配方Ra/R9为OK！");
            }else if(raTarget != null && r9 == null){
                return ResultUtils.success("默认当前配方Ra为OK！");
            }else{
                return ResultUtils.success("");
            }

        }

        return ResultUtils.success("");
    }

    /**
     * 获取主流程的工单信息
     * @param taskStateId
     * @return
     */
    @Override
    public Result getMainProcessTaskBaseInfo(Long taskStateId) {
        Map<String, Object> objectMap =  recordDao.getMainProcessTaskBaseInfo(taskStateId);
        Long outputRequireId = (Long)objectMap.get("outputRequireId");
        Map<String, Object> objectMap1 = recordDao.getOutPutRequirementParameters(outputRequireId);
        objectMap.putAll(objectMap1);
        return ResultUtils.success(objectMap);
    }

    /**
     *
     * @param taskStateId
     * @return
     */
    public Result getTaskProductFormulaRecord(Long taskStateId){
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);
        Integer processType = taskStateForDatabase.getProcessType();
        Integer processVersion = taskStateForDatabase.getProcessVersion();
        Long taskId = taskStateForDatabase.getTaskId();
        List<Map<String, Object>> formulaList = recordDao.getFormulaList(processType,processVersion,taskId);//配方列表

        for (Map<String, Object> t :
        formulaList) {
            Integer modelVersion = (Integer) t.get("modelVersion");
            System.out.println("processType:"+processType);
            System.out.println("processVersion:"+processVersion);
            System.out.println("taskId:"+taskId);
            System.out.println("modelVersion:"+modelVersion);
            List<Map<String,Object>> taskStateRatioInfoList = recordDao.getTaskStateRatioInfo(processType,processVersion,taskId, modelVersion);//配比列表
            List<Map<String,Object>> ratioInfoList = null;
            if( taskStateRatioInfoList == null || taskStateRatioInfoList.size() == 0 ){
                ratioInfoList = new ArrayList<>();
            }else {
                ratioInfoList = taskStateRatioInfoList.parallelStream().map(o -> {
                    Map<String,Object> map = new HashMap<>();
                    System.out.println("taskFormulaId: " + o.get("taskFormulaId").toString());
                    List<BsTaskFormulaDtl> materialRatioMapList =  recordDao.getTaskFormulaMaterialRatio(o.get("taskFormulaId").toString());//查询出具体的配比


                    Map<Byte,List<BsTaskFormulaDtl>> byteListMap = materialRatioMapList.parallelStream().collect(Collectors.groupingBy(BsTaskFormulaDtl::getMaterialClass));

                    map.put("glueA",byteListMap.get(MaterialClassEnum.AGLue.getStateFlag()).get(0));
                    map.put("glueB",byteListMap.get(MaterialClassEnum.BGLue.getStateFlag()).get(0));


                    List<BsTaskFormulaDtl> phosphors =  byteListMap.get(MaterialClassEnum.TPhosphors.getStateFlag());
                    if(phosphors != null && phosphors.size() > 0){
                        phosphors = phosphors.parallelStream().sorted(Comparator.comparing(BsTaskFormulaDtl::getMaterialId)).collect(toList());

                        //获取荧光粉波长密度
                        List<BsTaskFormulaDtl> phosphorsMapList =  recordDao.getTphosphorLenDen(o.get("taskFormulaId").toString());

                        for(BsTaskFormulaDtl btfd1 : phosphorsMapList){
                            //boolean flag = true;
                            for (BsTaskFormulaDtl btfd2 :  phosphors) {
                                if(btfd2.getId().equals(btfd1.getId())){
                                    if (btfd2.getSpec(). equals(btfd1.getSpec())){
                                        btfd2.setPeakWavelength(btfd1.getPeakWavelength());
                                        btfd2.setDensity(btfd1.getDensity());
                                        //flag = false;
                                    }
                                }
                            }
                            /*
                            if (flag) {
                                phosphors.add(btfd1);//给整合后集合添加子元素

                            }
                            */
                        }

                        /*
                        for (BsTaskFormulaDtl btfd :  phosphors) {
                            if(btfd.getMaterialId() == null){
                                phosphors.remove(btfd);
                            }
                        }
                        /
                        /*
                        for (A oldO : oldList) {
                            boolean flag = true;//给整合后集合添加子元素标志，true：添加，false:不添加，其年龄相加
                            for (A newO : newList) {
                                if (newO.getName(). equals(oldO.getName())) {//判断姓名是否相同
                                    newO.setAge(newO.getAge()+oldO.getAge());//姓名相同时，年龄相加
                                    flag = false;
                                }
                            }
                            if (flag) {
                                newList.add(oldO);//给整合后集合添加子元素
                            }
                        }
                        */
                    }
                    map.put("phosphor",phosphors);
                    List<BsTaskFormulaDtl> antiStarch = byteListMap.get(MaterialClassEnum.antiStarchMaterial.getStateFlag());
                    List<BsTaskFormulaDtl> diffusionPowder = byteListMap.get(MaterialClassEnum.diffusionPowderMaterial.getStateFlag());


                    if(antiStarch != null && antiStarch.size() != 0){
                        map.put("antiStarch",antiStarch.get(0));
                    }else {
                        map.put("antiStarch",null);
                    }
                    if(diffusionPowder != null && diffusionPowder.size() != 0 ){
                        map.put("diffusionPowder",diffusionPowder.get(0));
                    }else {
                        map.put("diffusionPowder",null);
                    }
                    map.putAll(o);
                    return map;
                }).collect(toList());
            }
            t.put("ratioList",ratioInfoList);
        }


        return ResultUtils.success(formulaList);
    }


    /**
     * 获取阀体和分光文件的生产记录
     * @param taskStateId
     * @param modelVersion
     * @param ratioVersion
     * @param stateType
     * @return
     */
    @Override
    public Result getEqptValveRecord(Long taskStateId, Integer modelVersion, Integer ratioVersion, Integer stateType){
        TaskStateForDatabase taskStateForDatabase = bsTaskStateDao.getTaskState(taskStateId);
        //stateType 0 试样，1是量产
        List<String> fileList = recordDao.getFileList(taskStateForDatabase.getTaskId(),taskStateForDatabase.getProcessType(),taskStateForDatabase.getProcessVersion(),
                modelVersion,ratioVersion,stateType);
        fileList.forEach(System.out::println);
        String strFileList = fileList.parallelStream().filter( s -> !s.isEmpty() && !",".equals(s) ).collect(Collectors.joining(","));
        System.out.println(strFileList);

        if(Strings.isEmpty(strFileList)){
            return ResultUtils.success(new ArrayList<>());
        }
        Set<Long> fileIdList = Arrays.asList(strFileList.split(",")).parallelStream().filter(s -> !s.isEmpty()).map(s -> Long.parseLong(s)).collect(Collectors.toSet());//去重后的fileId 集合
        List<EqptValveWithFile>  eqptValveWithFileList = recordDao.getEqptValveWithFileList(fileIdList);
        /*Map<String,List<EqptValveWithFile>>  listMap = eqptValveWithFileList.parallelStream().collect(Collectors.groupingBy(EqptValveWithFile::getGroupName));
        *//*for(String tempgroup : listMap.keySet()){
            List<EqptValveWithFile> temppositonList = listMap.get(tempgroup);
            temppositonList.parallelStream()
        }*/
        eqptValveWithFileList.forEach(o -> {
            String strOkFileList = o.getTeskOkFileIdList();
            if(Strings.isNotEmpty(strOkFileList)){
                List<Long> okFileList = Arrays.stream(strOkFileList.split(",")).filter(s -> !",".equals(s)).distinct().map(s -> Long.parseLong(s)).collect(toList());
                Integer oknum = recordDao.getJudgeNum(okFileList);
                o.setTestOkNum(oknum);
            }
            String strNgFileList = o.getTestNgFileList();
            if(Strings.isNotEmpty(strNgFileList)){
                List<Long> ngFileList = Arrays.stream(strNgFileList.split(",")).filter(s -> !",".equals(s)).distinct().map(s -> Long.parseLong(s)).collect(toList());
                Integer ngnum = recordDao.getJudgeNum(ngFileList);
                o.setTestNgNum(ngnum);
            }
        });
        Map<Long,List<EqptValveWithFile>> longListMap = eqptValveWithFileList.parallelStream().collect(Collectors.groupingBy(EqptValveWithFile::getEqptValveId));

        List<EqptValveWithFile> newEqptValveWithFile = new ArrayList<>();

        //聚合排序
        for (Long tempEqptValveId:
         longListMap.keySet()) {
            List<EqptValveWithFile> eqptValveWithFileList1 = longListMap.get(tempEqptValveId);

            EqptValveWithFile eqptValveWithFile = new EqptValveWithFile();
            String qcFileList = eqptValveWithFileList1.parallelStream().map(f -> f.getQcFileList()).collect(Collectors.joining(","));
            String fzckFileList = eqptValveWithFileList1.parallelStream().map(f -> f.getFzckFileIdList()).collect(Collectors.joining(","));
            String zckFileList = eqptValveWithFileList1.parallelStream().map(f -> f.getZckFileIdList()).collect(Collectors.joining(","));
            String testOkFileList = eqptValveWithFileList1.parallelStream().map(f -> f.getTeskOkFileIdList()).collect(Collectors.joining(","));
            String testNgFileList = eqptValveWithFileList1.parallelStream().map(f -> f.getTestNgFileList()).collect(Collectors.joining(","));
            Integer qcNum = eqptValveWithFileList1.parallelStream().map(item -> item.getQcNum()).reduce(0,(sum,item) -> sum + item );
            Integer fzckNum = eqptValveWithFileList1.parallelStream().map(item -> item.getFzckNum()).reduce(0,(sum,item) -> sum + item );
            Integer zckNum = eqptValveWithFileList1.parallelStream().map(item -> item.getZckNum()).reduce(0,(sum,item) -> sum + item );
            Integer teskOkNum = eqptValveWithFileList1.parallelStream().map(item -> item.getTestOkNum()).reduce(0,(sum,item) -> sum + item );
            Integer testNgNum = eqptValveWithFileList1.parallelStream().map(item -> item.getTestNgNum()).reduce(0,(sum,item) -> sum + item );

            String createTime = eqptValveWithFileList1.parallelStream().map(item -> item.getCreateTime()).reduce((one, two) -> {
                Integer num = one.compareTo(two);
                if(num > 0 ){
                    return one;
                }else if(num == 0){
                    return one;
                }else{
                    return two;
                }
            }).orElse("");


            eqptValveWithFile.setQcFileList(qcFileList);
            eqptValveWithFile.setFzckFileIdList(fzckFileList);
            eqptValveWithFile.setZckFileIdList(zckFileList);
            eqptValveWithFile.setTeskOkFileIdList(testOkFileList);
            eqptValveWithFile.setTestNgFileList(testNgFileList);
            eqptValveWithFile.setQcNum(qcNum);
            eqptValveWithFile.setFzckNum(fzckNum);
            eqptValveWithFile.setZckNum(zckNum);
            eqptValveWithFile.setTestOkNum(teskOkNum);
            eqptValveWithFile.setTestNgNum(testNgNum);

            eqptValveWithFile.setCreateTime(createTime);
            eqptValveWithFile.setGroupId(eqptValveWithFileList1.get(0).getGroupId());
            eqptValveWithFile.setGroupName(eqptValveWithFileList1.get(0).getGroupName());
            eqptValveWithFile.setEqptValveId(tempEqptValveId);
            eqptValveWithFile.setEqptValveName(eqptValveWithFileList1.get(0).getEqptValveName());
            eqptValveWithFile.setPositon(eqptValveWithFileList1.get(0).getPositon());
            eqptValveWithFile.setTaskStateId(eqptValveWithFileList1.get(0).getTaskStateId());

            newEqptValveWithFile.add(eqptValveWithFile);

        }
        newEqptValveWithFile.sort(Comparator.comparing(EqptValveWithFile::getPositon).thenComparing(EqptValveWithFile::getEqptValveId));
        return ResultUtils.success(newEqptValveWithFile);
    }

    /**
     * 获取分光文件测试结果列表
     * @param fileList
     * @return
     */
    @Override
    public Result getFileTestList(String fileList){
       List<String> fileIdList =  Arrays.asList(fileList.split(","));
       List<FileTestResult> testResults = recordDao.getFileTestResult(fileIdList);
       testResults.forEach(o -> {
           o.setDosageNum(recordDao.getDosage(o.getTaskStateId(),o.getEqptValueId()));
           o.setStateName(recordDao.getStateName(o.getTaskStateId(),o.getEqptValueId()));
       });
       return ResultUtils.success(testResults);
    }


    /**
     * 获取分光文件的判定结果
     * @param fileList
     * @return
     */
    @Override
    public Result getFileJudgeList(String fileList){
        List<String> fileIdList =  Arrays.asList(fileList.split(","));
        List<FileJudgeResult> fileJudgeResults = recordDao.getFileJudgeResult(fileIdList);
        return ResultUtils.success(fileJudgeResults);
    }

    /**
     * 获取判定记录列表
     * @param fileList
     * @return
     */
    @Override
    public Result getJudgeRecord(String fileList){
        List<String> fileIdList =  Arrays.asList(fileList.split(","));
        List<FileJudgeRecord> fileJudgeRecordList = recordDao.getFileJudgeRecord(fileIdList);
        fileJudgeRecordList.forEach(o -> {
            o.setTestInfo(recordDao.getTestResult(Arrays.asList(o.getFileIdList().split(","))));
        });
        return  ResultUtils.success(fileJudgeRecordList);
    }



}
