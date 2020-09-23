package com.wiseq.cn.ykAi.service.serviceimpl;
import	java.security.cert.PKIXRevocationChecker.Option;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.BomSourceEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.*;
import com.wiseq.cn.httpRequest.MLSAiInterface;
import com.wiseq.cn.utils.ListUtil;
import com.wiseq.cn.ykAi.dao.TBomDao;
import com.wiseq.cn.ykAi.service.TBomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class TBomServiceImpl implements TBomService {
    @Autowired
    private TBomDao tBomDao;




//    /**
//     * 新增
//     * @param record
//     * @return
//     */
//    int insertSelective(TBom record){
//
//    }

   /* *//**
     * 删除
     * @param id
     * @return
     *//*
    int deleteByPrimaryKey(Long id);
*/

    /**
     * 机种BOM编辑
     * @param tbomUpdatePage
     * @return
     */
    @Override
    @Transactional
    public Result bomUpdate(TBOMUpdatePage tbomUpdatePage){
        //新增的
        List<TBom> addList=tbomUpdatePage.getAddList();
        //删除的
        List<TBom> deleteList=tbomUpdatePage.getDeleteList();
        //修改的
        List<TBom> updateList=tbomUpdatePage.getUpdateList();

        //bom 荧光粉中间表
        List<TBomPhosphor> tBomPhosphors = new ArrayList<>();

        //只有一个新增时的判定
        if(addList.size()==1 &&deleteList.size()==0 && updateList.size()==0){
            //Long aglueId = addList.get(0).getAglueId();
            //Long bguleId = addList.get(0).getBglueId();
          /*  TBom addBom = addList.get(0);
            Long glueId = addBom.getGlueId();
            Long antiStarchId = addBom.getAntiStarchId();
            Long diffusionPowderId =  addBom.getDiffusionPowderId();
            Long typeMachineId = addBom.getTypeMachineId();
            //Long chipId = addList.get(0).getChipId();

            List<TPhosphor> tPhosphorList = addBom.getTPhosphors();
            //判断所用芯片是否相同
            //List<TIdAndNum> chipList = addList.get(0).getChipList();


            List<Long> currentPhosphorIdList = tPhosphorList.stream().map(TPhosphor::getId).collect(Collectors.toList());
            List<Long> currentChipIdList = addBom.getChipList().stream().map(iteam -> iteam.getChipId().longValue()).collect(Collectors.toList());


            //验证重复性
            List<TBomMaterial> bomPhosphorList = this.tBomDao.findExitForMaterialPhosphor(antiStarchId,typeMachineId,glueId,diffusionPowderId);
            Map<Long,List<TBomMaterial>> bomPhosphorMap = bomPhosphorList.stream().collect(Collectors.groupingBy(TBomMaterial::getBomId));
            List<TBomMaterial> bomChiplList = this.tBomDao.findExitForMaterialChip(antiStarchId,typeMachineId,glueId,diffusionPowderId);
            Map<Long,List<TBomMaterial>> bomChiplMap = bomChiplList.stream().collect(Collectors.groupingBy(TBomMaterial::getBomId));

            for (Map.Entry<Long,List<TBomMaterial>> longListEntry:
            bomPhosphorMap.entrySet()) {
                Long tempBomId = longListEntry.getKey();
                List<Long> tempPhosphorIdList = longListEntry.getValue().stream().map(TBomMaterial::getMaterialId).collect(Collectors.toList());
                List<Long> tempChipIdList = bomChiplMap.get(tempBomId).stream().map(TBomMaterial::getMaterialId).collect(Collectors.toList());
                if(ListUtil.isListEqual(tempPhosphorIdList,currentPhosphorIdList) && ListUtil.isListEqual(tempChipIdList,currentChipIdList)){
                    Result error = ResultUtils.error(1, "bom所用原材料和现有原材料重复");
                    return  error;
                }
            }

           *//* bomPhosphorMap.entrySet().forEach(longListEntry -> {
                Long tempBomId = longListEntry.getKey();
                List<Long> tempPhosphorIdList = longListEntry.getValue().stream().map(TBomMaterial::getMaterialId).collect(Collectors.toList());
                List<Long> tempChipIdList = bomChiplMap.get(tempBomId).stream().map(TBomMaterial::getMaterialId).collect(Collectors.toList());
                if(ListUtil.isListEqual(tempPhosphorIdList,currentPhosphorIdList) && ListUtil.isListEqual(tempChipIdList,currentChipIdList)){
                    Result error2 = ResultUtils.error(1, "bom所用原材料和现有原材料重复");
                    Result error21 = error2;
                    return  error21;
                }

            });*//*

           *//* for (Long t:
                    bomList2) {
                List<Long> phosphorLis2 = this.tBomDao.findTPhosphorList(t);

                if(isEquals(phosphorLis1,phosphorLis2)){
                    return ResultUtils.error(1,"bom所用原材料和现有原材料重复");
                }
            }
*//*
            Integer num = this.tBomDao.finExit(addList.get(0).getBomCode(),addList.get(0).getTypeMachineId());
            if(num>0){
                return ResultUtils.error(1,"编码重复");
            }*/
           Result result = checkBomRepeatForAdd(addList.get(0));
           if(!result.getCode().equals(0)){
               return result;
           }
            Integer num = this.tBomDao.finExit(addList.get(0).getBomCode(),addList.get(0).getTypeMachineId());
            if(num>0){
                return ResultUtils.error(2,"编码重复");
            }
        }

        //批量新增非单个包括单个
        for (TBom tBom:
        addList) {
            this.tBomDao.insertSelective(tBom);
            List<TPhosphor> tPhosphors = tBom.getTPhosphors();
            List<TBomChip> tChips = tBom.getChipList();//芯片列表
            for (TPhosphor t :
             tPhosphors) {
                TBomPhosphor  tBomPhosphor = new TBomPhosphor();
                tBomPhosphor.setBomId(tBom.getId());
                tBomPhosphor.setPhosphorId(t.getId());
                tBomPhosphors.add(tBomPhosphor);
            }
            //新增bom和芯片的中间表
            this.tBomDao.insertChipList(tChips,tBom.getId());
            Integer bomSource = tBom.getBomSource();


            if(BomSourceEnum.SystemRecommed.getStateFlag().equals(bomSource)){
                TbomTargetParameter tbomTargetParameter = this.tBomDao.selectTypeMachineTargetParameter(tBom.getTypeMachineId());
                tbomTargetParameter.setBomId(tBom.getId());
                tBomDao.insertTBomTargetParameter(tbomTargetParameter);
                tBomDao.insertTBomPhosphorForRecommended(tBom.getId(),tBom.getMustUsePhosphorId(),tBom.getProhibitedPhosphorId(),tBom.getLimitPhosphorType());
            }
        }

        if(tBomPhosphors.size() > 0) {
            this.tBomDao.batchInsertBomPhosphor(tBomPhosphors);
        }

        //删除
        for (TBom tBom:
                deleteList) {
            this.tBomDao.deleteChipListByBomId(tBom.getId());
            this.tBomDao.deleteByPrimaryKey(tBom.getId());
        }


        //bom没有修改功能暂时不用
        if(updateList.size()>0){
            for (TBom t:
            updateList) {
                //修改bom信息如果传过来的值为null则不修改
              this.tBomDao.updateByPrimaryKeySelective(t);
            }
        }
        return ResultUtils.success();

    }

    /**
     * 通过机种ID获取这个机种的所有BOM组合，暂不包含荧光粉
     * @param typeMachineId
     * @return
     */
    @Override
    public TBomListPage selectAllByTypeMachineId( Long typeMachineId,
                                                Boolean isTemp,
                                                String bomCode,
                                                Byte bomType,
        Integer bomSource){
        TBomListPage tBomListPage = new TBomListPage();
        List<TBom> tBomList = tBomDao.selectAllByTypeMachineId(typeMachineId, isTemp, bomCode, bomType,bomSource);


        for (TBom tbom: tBomList
             ) {
            tbom.setTPhosphors(tBomDao.selectPhosphorByBomId(tbom.getId()));
            tbom.setChipList(tBomDao.getChipList(tbom.getId()));
        }

        IntSummaryStatistics intSummaryStatistics = tBomList.stream().mapToInt( iteam ->iteam.getTPhosphors().size() ).summaryStatistics();

        tBomListPage.setMaxLength(intSummaryStatistics.getMax());
        tBomListPage.setTBoms(tBomList);
        return tBomListPage;
    }




    /**
     * 获取所有非禁用和删除的胶水列表
     * @return
     */
    @Override
    public List<TABGlue> getTGlues(){
        return this.tBomDao.getTGlues();
    }


    /**
     * 获取所有非禁用和删除的芯片列表
     * @return
     */
    @Override
    public List<TChip> getTChips(){
        return this.tBomDao.getTChips();
    }

    /**
     * 获取所有非禁用和删除的荧光粉列表
     * @return
     */
    @Override
    public List<TPhosphor> getTPhosphors(){
        return this.tBomDao.getTPhosphors();
    }

    /**
     * 获取所有非禁用和删除的支架列表
     * @return
     */
    @Override
    public List<TScaffold> getTScaffolds(){
        return this.tBomDao.getTScaffolds();
    }



    public static boolean isEquals(List<Long> list1,List<Long> list2){
        if(null != list1 && null != list2){
            //包含
            if(list1.containsAll(list2) && list2.containsAll(list1)){
                return true;
            }
            return false;
        }
        return true;
    }

    @Override
    public TBom selectBomByBomId(Long bomId){
        TBom tBom = this.tBomDao.getBomById(bomId);
        tBom.setTPhosphors(tBomDao.selectPhosphorByBomId(bomId));
        List<TBomChip>  chipList = tBomDao.getChipList(bomId);
        tBom.setChipList(chipList);
        return tBom;
    }

    /**
     * 获取系统推荐时所设置的相关参数
     * @param bomId
     * @return
     */
    @Override
    public Map<String,Object> getSystemRecommedSetUpParameters(Long bomId){
        Map<String,Object> data = new HashMap<>();
        Map<String,Object> targetParameter = this.tBomDao.getTBomSystemRecommendTargetParameter(bomId);
        List<Map<String,Object>> limitType = this.tBomDao.getBomPhosphorForRecommendedlimitPhosphorType(bomId);
        List<Map<String,Object>> bomMustUsePhosphor = this.tBomDao.getBomMustUsePhosphor(bomId);
        List<Map<String,Object>> bomProhibitedPhosphor = this.tBomDao.getBomProhibitedPhosphor(bomId);
        data.put("targetParameter",targetParameter);
        data.put("limitType",limitType);
        data.put("bomMustUsePhosphor",bomMustUsePhosphor);
        data.put("bomProhibitedPhosphor",bomProhibitedPhosphor);
        return data;
    }

    /**
     * 离线推荐bom
     * @param offLineRecommendFrontToBack
     * @return
     */
    @Override
    public Result offLineRecommendBom(OffLineRecommendFrontToBack offLineRecommendFrontToBack){
        Integer typeMachineId = offLineRecommendFrontToBack.getTypeMachineId();
        String mustUsePhosphorId = offLineRecommendFrontToBack.getMustUsePhosphorId();
        String limitPhosphorType = offLineRecommendFrontToBack.getLimitPhosphorType();
        if(mustUsePhosphorId == null || "".equals(mustUsePhosphorId)){
            mustUsePhosphorId = "0";
        }
        String prohibitedPhosphorId = offLineRecommendFrontToBack.getProhibitedPhosphorId();
        if(prohibitedPhosphorId == null || "".equals(prohibitedPhosphorId) ){
            prohibitedPhosphorId = "0";
        }
        List<Long> chipIdList= offLineRecommendFrontToBack.getChipIdList();
        Long glueId = offLineRecommendFrontToBack.getGlueId();
        Long diffusionPowderId = offLineRecommendFrontToBack.getDiffusionPowderId();

        if(diffusionPowderId == null){
            diffusionPowderId = 0l;
        }

        Long scaffoldId = offLineRecommendFrontToBack.getScaffoldId();

        Long antiStarchId = offLineRecommendFrontToBack.getAntiStarchId();

        if(antiStarchId == null){
            antiStarchId = 0l;
        }

        List<String> stringChipIdList = chipIdList.stream().map(item->item.toString()).collect(Collectors.toList());

        String chip_Id_list = String.join(",",stringChipIdList);



        String  strResult = MLSAiInterface.recommendBom(typeMachineId,mustUsePhosphorId,prohibitedPhosphorId,chip_Id_list,glueId,scaffoldId,diffusionPowderId,antiStarchId,limitPhosphorType);
        JSONObject jsonObject = JSON.parseObject(strResult);
        Integer code = jsonObject.getInteger("code");
        String message = jsonObject.getString("msg");

        if(code.equals(0)){
            JSONObject data = jsonObject.getJSONObject("data");
            String powder1 = data.getString("power_id1");
            String powder2 = data.getString("power_id2");
            String powder3 = data.getString("power_id3");
            List mapList = tBomDao.getPosphorByIdList(Arrays.asList(powder1,powder2,powder3));
            return ResultUtils.setResult(code,message,mapList);
        }
        message = message + jsonObject.getString("data");
        return ResultUtils.error(code,message);
    }

    /**
     * 在线推BOM生产过程中推荐BOM
     * @return
     */
    @Override
    public Result onLineRecommendBom(OnLineRecommendFrontToBack onLineRecommendFrontToBack){
        Integer type = onLineRecommendFrontToBack.getType();
        String mustUsePhosphorId = onLineRecommendFrontToBack.getMustUsePhosphorId();
        if(mustUsePhosphorId == null || "".equals(mustUsePhosphorId)){
            mustUsePhosphorId = "0";
        }
        String prohibitedPhosphorId = onLineRecommendFrontToBack.getProhibitedPhosphorId();
        if(prohibitedPhosphorId == null || "".equals(prohibitedPhosphorId) ){
            prohibitedPhosphorId = "0";
        }
        Integer taskId = onLineRecommendFrontToBack.getTaskId();
        Integer modelId = onLineRecommendFrontToBack.getModelId();
        List<Long> tChipWlRankList = onLineRecommendFrontToBack.getTChipWlRankList();
        List<String> stringList = tChipWlRankList.stream().map(item -> item.toString()).collect(Collectors.toList());
        String stringChipWlRankId = String.join(",",stringList);
        String limitPhosphorType = onLineRecommendFrontToBack.getLimitPhosphorType();


        String strResult = MLSAiInterface.updateBom(type, mustUsePhosphorId, prohibitedPhosphorId, taskId, modelId,stringChipWlRankId,limitPhosphorType);
        JSONObject jsonObject = JSON.parseObject(strResult);
        Integer code = jsonObject.getInteger("code");
        String message = jsonObject.getString("msg");


        if(code.equals(0)){
            JSONObject data = jsonObject.getJSONObject("data");
            String powder1 = data.getString("power_id1");
            String powder2 = data.getString("power_id2");
            String powder3 = data.getString("power_id3");
            List mapList = tBomDao.getPosphorByIdList(Arrays.asList(powder1,powder2,powder3));
            return ResultUtils.setResult(code,message,mapList);
        }
        message = message + jsonObject.getString("data");
        return ResultUtils.error(code,message);
    }

    /**c
     * 用于验证bom材料是否重复和本机种的其它bom比较
     * @param tBom
     * @return
     */
    @Override
    public Result checkBomRepeatForEAS(TBom tBom){
        Long repeatBomId = null;
        Long glueId = tBom.getGlueId();
        Long antiStarchId = tBom.getAntiStarchId();
        Long diffusionPowderId =  tBom.getDiffusionPowderId();
        Long typeMachineId = tBom.getTypeMachineId();
        //Long chipId = addList.get(0).getChipId();

        List<TPhosphor> tPhosphorList = tBom.getTPhosphors();
        //判断所用芯片是否相同
        //List<TIdAndNum> chipList = addList.get(0).getChipList();


        List<Long> currentPhosphorIdList = tPhosphorList.stream().map(TPhosphor::getId).collect(Collectors.toList());
        List<Long> currentChipIdList = tBom.getChipList().stream().map(iteam -> iteam.getChipId().longValue()).collect(Collectors.toList());


        //验证重复性
        List<TBomMaterial> bomPhosphorList = this.tBomDao.findExitForMaterialPhosphor(antiStarchId,typeMachineId,glueId,diffusionPowderId);
        Map<Long,List<TBomMaterial>> bomPhosphorMap = bomPhosphorList.stream().collect(Collectors.groupingBy(TBomMaterial::getBomId));
        List<TBomMaterial> bomChiplList = this.tBomDao.findExitForMaterialChip(antiStarchId,typeMachineId,glueId,diffusionPowderId);
        Map<Long,List<TBomMaterial>> bomChiplMap = bomChiplList.stream().collect(Collectors.groupingBy(TBomMaterial::getBomId));

        for (Map.Entry<Long,List<TBomMaterial>> longListEntry:
                bomPhosphorMap.entrySet()) {
            Long tempBomId = longListEntry.getKey();
            List<Long> tempPhosphorIdList = longListEntry.getValue().stream().map(TBomMaterial::getMaterialId).collect(Collectors.toList());
            List<Long> tempChipIdList = bomChiplMap.get(tempBomId).stream().map(TBomMaterial::getMaterialId).collect(Collectors.toList());
            if(ListUtil.isListEqual(tempPhosphorIdList,currentPhosphorIdList) && ListUtil.isListEqual(tempChipIdList,currentChipIdList)){
                repeatBomId = tempBomId;
                Result error = ResultUtils.setResult(0, "1",repeatBomId);
                return  error;
            }
        }
        return ResultUtils.setResult(0, "0",null);
    }

    /**c
     * 验证bom重复
     * @param tBom
     * @return
     */
    private Result checkBomRepeatForAdd(TBom tBom){
        Long repeatBomId = null;
        Long glueId = tBom.getGlueId();
        Long antiStarchId = tBom.getAntiStarchId();
        Long diffusionPowderId =  tBom.getDiffusionPowderId();
        Long typeMachineId = tBom.getTypeMachineId();
        //Long chipId = addList.get(0).getChipId();

        List<TPhosphor> tPhosphorList = tBom.getTPhosphors();
        //判断所用芯片是否相同
        //List<TIdAndNum> chipList = addList.get(0).getChipList();


        List<Long> currentPhosphorIdList = tPhosphorList.stream().map(TPhosphor::getId).collect(Collectors.toList());
        List<Long> currentChipIdList = tBom.getChipList().stream().map(iteam -> iteam.getChipId().longValue()).collect(Collectors.toList());


        //验证重复性
        List<TBomMaterial> bomPhosphorList = this.tBomDao.findExitForMaterialPhosphor(antiStarchId,typeMachineId,glueId,diffusionPowderId);
        Map<Long,List<TBomMaterial>> bomPhosphorMap = bomPhosphorList.stream().collect(Collectors.groupingBy(TBomMaterial::getBomId));
        List<TBomMaterial> bomChiplList = this.tBomDao.findExitForMaterialChip(antiStarchId,typeMachineId,glueId,diffusionPowderId);
        Map<Long,List<TBomMaterial>> bomChiplMap = bomChiplList.stream().collect(Collectors.groupingBy(TBomMaterial::getBomId));

        for (Map.Entry<Long,List<TBomMaterial>> longListEntry:
                bomPhosphorMap.entrySet()) {
            Long tempBomId = longListEntry.getKey();
            List<Long> tempPhosphorIdList = longListEntry.getValue().stream().map(TBomMaterial::getMaterialId).collect(Collectors.toList());
            List<Long> tempChipIdList = bomChiplMap.get(tempBomId).stream().map(TBomMaterial::getMaterialId).collect(Collectors.toList());
            if(ListUtil.isListEqual(tempPhosphorIdList,currentPhosphorIdList) && ListUtil.isListEqual(tempChipIdList,currentChipIdList)){
                repeatBomId = tempBomId;
                Result error = ResultUtils.setResult(1, "bom所用原材料和现有原材料重复",repeatBomId);
                return  error;
            }
        }
        return ResultUtils.success();
    }


    @Override
    @Transactional
    public Result addBom(TBom tBom) {
        //bom 荧光粉中间表
        List<TBomPhosphor> tBomPhosphors = new ArrayList<>();
        Result result = checkBomRepeatForAdd(tBom);

        if(!result.getCode().equals(0)){
            return result;
        }
        Integer num = this.tBomDao.finExit(tBom.getBomCode(),tBom.getTypeMachineId());
        if(num>0){
            return ResultUtils.error(2,"编码重复");
        }
        this.tBomDao.insertSelective(tBom);
        List<TPhosphor> tPhosphors = tBom.getTPhosphors();
        List<TBomChip> tChips = tBom.getChipList();//芯片列表
        for (TPhosphor t :
                tPhosphors) {
            TBomPhosphor  tBomPhosphor = new TBomPhosphor();
            tBomPhosphor.setBomId(tBom.getId());
            tBomPhosphor.setPhosphorId(t.getId());
            tBomPhosphors.add(tBomPhosphor);
        }

        //新增bom和芯片的中间表
        this.tBomDao.insertChipList(tChips,tBom.getId());
        Integer bomSource = tBom.getBomSource();


        if(BomSourceEnum.SystemRecommed.getStateFlag().equals(bomSource)){
            TbomTargetParameter tbomTargetParameter = this.tBomDao.selectTypeMachineTargetParameter(tBom.getTypeMachineId());
            tbomTargetParameter.setBomId(tBom.getId());
            tBomDao.insertTBomTargetParameter(tbomTargetParameter);
            tBomDao.insertTBomPhosphorForRecommended(tBom.getId(),tBom.getMustUsePhosphorId(),tBom.getProhibitedPhosphorId(),tBom.getLimitPhosphorType());
        }

        if(tBomPhosphors.size() > 0) {
            this.tBomDao.batchInsertBomPhosphor(tBomPhosphors);
        }

        return ResultUtils.setResult(0,"成功",tBom.getId());
    }

    @Override
    public Result getUseCurrentBomAiModelList(Long bomId) {
        List<Map<String,Object>> result = this.tBomDao.getUseCurrentBomAiModelList(bomId);
        return ResultUtils.success(result);
    }

    @Override
    public Result deleteBom(Long bomId) {
        this.tBomDao.deleteByBomId(bomId);
        return ResultUtils.success();
    }

    @Override
    public Result getBomMinimumWavelengthPhosphor(Long bomId) {
        return ResultUtils.success(this.tBomDao.getBomMinimumWavelengthPhosphor(bomId));
    }

    public static void main(String[] args) {
        TBomChip tBomChip1 =  new TBomChip();
        tBomChip1.setChipId(1);
        TBomChip tBomChip2 =  new TBomChip();
        TBomChip tBomChip3 =  new TBomChip();
        TBomChip tBomChip4 =  new TBomChip();
        TBomChip tBomChip5 =  new TBomChip();
        tBomChip2.setChipId(2);
        tBomChip3.setChipId(3);
        tBomChip4.setChipId(4);
        tBomChip5.setChipId(4);
        List<TBomChip> tBomChipList= Arrays.asList(tBomChip1,tBomChip2,tBomChip3,tBomChip4,tBomChip5);
        List<String> chipIdList = tBomChipList.stream().map(item->item.getChipId().toString()).collect(Collectors.toList());
        String stringChipIdList= String.join(",",chipIdList);
       System.out.println(stringChipIdList);
    }
}
