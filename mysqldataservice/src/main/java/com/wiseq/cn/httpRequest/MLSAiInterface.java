package com.wiseq.cn.httpRequest;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.*;
import com.wiseq.cn.utils.HttpUtil;
import io.swagger.models.auth.In;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/20     jiangbailing      原始版本
 * 文件说明: 木林森算法调用接口
 */
public class MLSAiInterface {
    /**1
     * spec规则判定
     */
    private static  final  String  specDecisionRule = "/api/spc/rulecheck/";
    /**2
     * 分光文件解析
     */
    private static  final  String  SplittingLightFileParsing ="/api/fileparse/";
    /**3
     * 分光文件分析
     */
    private static  final  String  SplittingLightFileAnalyze="/api/fileinfos/";
    /**4
     * 数据库中查询分光文件分析结果接口
     */
    private static  final  String GetSplittingLightFileResultFORDatabase="/api/fileanalysis/";
    /**5
     *基于出货比例拟合目标中心点接口
     */
    private static  final  String centerpoint="/api/model/centerpoint/";
    /**6
     * 生产过程中模型建立接口
     */
    private static  final  String prductModelBuild="/api/model/update/";
    /**7
     *  配比库中模型建立接口
     */
    private static  final  String customModelBuild="/api/model/custom/";
    /**8
     * 配比推荐接口
     */
    private static  final  String modelRecommend="/api/model/recommend/";

    /**9
     * 模型筛选
     */
    private static final  String  modelFilter = "/api/model/tasklist/";

    /**
     * 拟合中心点
     */
    private static final  String  getCenterpoint = "/api/model/centerpoint_init";


    /**1
     * spec规则调用
     * @param taskId 任务单状态ID
     * @param modelId 当前工单的最新模型ID
     * @param testType 分光文件类型 0 正常烤文件 1 非正常烤文件 2 前测文件
     * @param eqptId 点胶机设备id
     * @param valveId 点胶机阀体id
     */
    public Result<AiSpecRule> specDecisionRuleMethod(Long taskId,Long modelId,Byte testType,Long eqptId,Long valveId){
        StringBuffer sb_specDecisionRule = new StringBuffer(specDecisionRule);
        sb_specDecisionRule.append(taskId);
        sb_specDecisionRule.append("/");
        sb_specDecisionRule.append(modelId);
        sb_specDecisionRule.append("/");
        sb_specDecisionRule.append(testType);
        sb_specDecisionRule.append("/");
        sb_specDecisionRule.append(eqptId);
        sb_specDecisionRule.append("/");
        sb_specDecisionRule.append(valveId);
        String result = HttpUtil.HttpRequest(sb_specDecisionRule.toString());
        AiResut aiResut = JSON.parseObject(result,AiResut.class);
        Result<AiSpecRule> aiResutResult = new Result<>();
        aiResutResult.setCode(aiResut.getCode());
        aiResutResult.setMessage(aiResut.getMsg());
        if(aiResut.getCode()==0){
            aiResutResult.setData(aiResut.getData().toJavaObject(AiSpecRule.class));
        }
        return aiResutResult;
    }

    /**2
     * 分光文件解析
     * 分光文件id
     * @param fileId
     */
    public Result<AiSplittingLightFileParse> splittingLightFileParsingMethod(Long fileId){
        StringBuffer sb_splittingLightFileParsing = new StringBuffer(SplittingLightFileParsing);
        sb_splittingLightFileParsing.append(fileId);
        String result = HttpUtil.HttpRequest(sb_splittingLightFileParsing.toString());
        AiResut aiResut = JSON.parseObject(result,AiResut.class);
        Result<AiSplittingLightFileParse> aiResutResult = new Result<>();
        aiResutResult.setCode(aiResut.getCode());
        aiResutResult.setMessage(aiResut.getMsg());
        if(aiResutResult.getCode()==0){
            aiResutResult.setData(aiResut.getData().toJavaObject(AiSplittingLightFileParse.class));
        }
        return aiResutResult;
    }

    /**3
     * 分光文件分析
     * @param fileId
     */
    public Result<AiSplittingLightFileAnalyzeInfo> splittingLightFileAnalyzeMethod(Long fileId){
        StringBuffer sb_splittingLightFileAnalyze = new StringBuffer(SplittingLightFileAnalyze);
        sb_splittingLightFileAnalyze.append(fileId);
        String result = HttpUtil.HttpRequest(sb_splittingLightFileAnalyze.toString());
        AiResut aiResut = JSON.parseObject(result,AiResut.class);
        Result<AiSplittingLightFileAnalyzeInfo> aiResutResult = new Result<>();
        aiResutResult.setCode(aiResut.getCode());
        aiResutResult.setMessage(aiResut.getMsg());
        if(aiResut.getCode()==0){
            aiResutResult.setData(aiResut.getData().toJavaObject(AiSplittingLightFileAnalyzeInfo.class));
        }

        return aiResutResult;
    }


     /**4
     *数据库中查询分光文件分析结果接口
      * @param fileId
     */
    public Result<AiSplittingLightFileAnalyzeInfo> getSplittingLightFileResultFORDatabaseMethod(Long fileId){
        StringBuffer sb_getSplittingLightFileResultFORDatabase = new StringBuffer(GetSplittingLightFileResultFORDatabase);
        sb_getSplittingLightFileResultFORDatabase.append(fileId);
        String result = HttpUtil.HttpRequest(sb_getSplittingLightFileResultFORDatabase.toString());
        AiResut aiResut = JSON.parseObject(result,AiResut.class);
        Result<AiSplittingLightFileAnalyzeInfo> aiResutResult = new Result<>();
        aiResutResult.setCode(aiResut.getCode());
        aiResutResult.setMessage(aiResut.getMsg());
        if(aiResut.getCode() == 0){
            aiResutResult.setData((aiResut.getData().toJavaObject(AiSplittingLightFileAnalyzeInfo.class)));
        }
        return aiResutResult;
    }


    /**5
     *
     * 基于出货比例拟合目标中心点接口
     * @param modelId
     * @param outputRequireId
     * @param fileId 第一次和配比绑定时为0
     */
    public Result<AiCenterPoint> centerpointMethod(Long modelId,Long outputRequireId,Long fileId){
        StringBuffer sb_centerpoint = new StringBuffer(centerpoint);
        sb_centerpoint.append(modelId);
        sb_centerpoint.append("/");
        sb_centerpoint.append(outputRequireId);
        sb_centerpoint.append("/");
        sb_centerpoint.append(fileId);
        String result = HttpUtil.HttpRequest(sb_centerpoint.toString());
        AiResut aiResut = JSON.parseObject(result,AiResut.class);
        Result<AiCenterPoint> aiResutResult = new Result<>();
        aiResutResult.setCode(aiResut.getCode());
        aiResutResult.setMessage(aiResut.getMsg());
        if(aiResut.getCode() == 0){
            aiResutResult.setData(aiResut.getData().toJavaObject(AiCenterPoint.class));
        }
        return aiResutResult;
    }

    /**6
     *生产过程中模型建立接口
     * @param taskStateId 当前建模型的工单状态ID
     * @param modelId 模型ID
     */
    public AiResut prductModelBuildMethod(Long taskStateId,Long modelId){
        StringBuffer sb_prductModelBuild = new StringBuffer(prductModelBuild);
        sb_prductModelBuild.append(taskStateId);
        sb_prductModelBuild.append("/");
        sb_prductModelBuild.append(modelId);
        String result = HttpUtil.HttpRequest(sb_prductModelBuild.toString());
        AiResut aiResut = JSON.parseObject(result,AiResut.class);
        return aiResut;
    }


    /**7
     * 配比库中模型建立接口
     * @param taskId 工单ID
     * @param modelId
     */
    public AiResut customModelBuildMethod(Long taskId,Long modelId){
        StringBuffer sb_customModelBuild = new StringBuffer(customModelBuild);
        sb_customModelBuild.append(taskId);
        sb_customModelBuild.append("/");
        sb_customModelBuild.append(modelId);
        String result = HttpUtil.HttpRequest(sb_customModelBuild.toString());
        AiResut aiResut = JSON.parseObject(result,AiResut.class);
        return aiResut;
    }

    /**8
     * 配比推荐接口
     * 生产过程中调用该接口，task_state_id为推配比的工单状态；
     * 配比库中调用该接口，task_state_id为None。
     *
     * @param recommendModelId 需要推荐配比的模型ID
     * @param taskStateId 生产过程中推荐配比的工单状态ID 不在生产过程中推配比传0，在生产过程中推配比传具体的工单状态ID
     * @param modelingModelId 建模型数据的模型ID
     */
    public Result<Map<Long,Double>> modelRecommendMethod(Long recommendModelId,Long taskStateId,Long modelingModelId){
        StringBuffer sb_modelRecommend = new StringBuffer(modelRecommend);
        sb_modelRecommend.append(recommendModelId);
        sb_modelRecommend.append("/");
        sb_modelRecommend.append(taskStateId);
        sb_modelRecommend.append("/");
        sb_modelRecommend.append(modelingModelId);
        String result = HttpUtil.HttpRequest(sb_modelRecommend.toString());
        AiResut aiResut = JSON.parseObject(result,AiResut.class);
        Result<Map<Long,Double>> result1 = new Result<>();
        result1.setCode(aiResut.getCode());
        result1.setMessage(aiResut.getMsg());
        if(aiResut.getCode()==0){
             aiResut.getData();
            Map<Long,Double>  longDoubleMap = aiResut.getData().toJavaObject(Map.class);
            result1.setData(longDoubleMap);
        }
        return result1;
    }


    /**
     * 新的模型id
     * @param newModelId
     * @return
     */
    public Result<List<AiModelFilter>> modelModelFilterMethod(Long newModelId){
        StringBuffer sb_modelFilter = new StringBuffer(modelFilter);
        sb_modelFilter.append(newModelId);
        String result = HttpUtil.HttpRequest(sb_modelFilter.toString());
        JSONObject jbstr = JSONObject.parseObject(result);
        Integer code = jbstr.getInteger("code");
        String msg = jbstr.getString("msg");
        List<AiModelFilter> listResult = new ArrayList<>();
        if(code == 0){
            JSONArray jsonArray = jbstr.getJSONArray("data");
            List<AiModelFilter> aiModelFilterList = jsonArray.toJavaList(AiModelFilter.class);
            return ResultUtils.success(aiModelFilterList);
        }
        return ResultUtils.error(code,msg);
    }


    /**
     * 中心点
     * @param jsonStr
     * @return
     */
    public Result centerpointMethodFirst(String jsonStr){
        String result = HttpUtil.doHttpPost(jsonStr,getCenterpoint);
        if("0".equals(result)){
            return ResultUtils.error(1,"算法连接失败");
        }
        AiResut aiResut = JSON.parseObject(result,AiResut.class);
        Result aiResutResult = new Result<>();
        aiResutResult.setCode(aiResut.getCode());
        aiResutResult.setMessage(aiResut.getMsg());
        System.out.println(aiResut.getData());
        if(aiResut.getCode() == 0){
            return ResultUtils.success(aiResut.getData());
        }
        return  aiResutResult;
    }



    public static void main(String[] args) {
        String mapjson = "{1:2,3:2}";
        String json = "";
        Object object = JSON.parse(mapjson);
        Map<Integer,Integer> map = (Map<Integer,Integer>)object;
        System.out.println(object);
        System.out.println(map.get(3));


        Long l = 1l;
        Integer i = new Long(l).intValue();
    }
    //离线推BOM接口
    private static  final  String recommendBom = "/api/model/recommendBom/";
    //在线推BOM接口
    private static  final  String updateBom = "/api/model/updateBom/";
    //带显指的配比推荐
    private static  final  String recommendRatio = "/api/model/recommendRatio";
    //NG建议判断
    private static  final  String ngProposeJudge = "/api/model/ngProposeJudge";
    //试配打点开始推荐
    private static final  String  getDadianRatio = "/api/model/dadianRatio";

    /**
     离线推BOM接口
     * 调用条件
     * 1. 机种库》编辑bom》系统推荐
     * 2. 开始试样，判断波长与显指要求不符，不满足以下要求
     * @param type_machine_id 机种id
     * @param use_power 必用荧光粉id 多个,分割 没有为0
     * @param forbid_power 禁用荧光粉id 多个,分割 没有为0
     * @param chip_Id_list 默认使用的芯片id
     * @param glueId 胶水id
     * @param scaffoldId 支架
     * @param diffusionPowderId 扩散粉 没有 0
     * @param antiStarchId 坑沉点粉 没有 0
     * @param limitPhosphorType 允许使用的荧光粉类型
     * @return
     */
    public static  String recommendBom(Integer type_machine_id,String use_power,String forbid_power,String chip_Id_list,Long glueId,Long scaffoldId,Long diffusionPowderId,Long antiStarchId,String limitPhosphorType){
        StringBuffer sb = new StringBuffer(recommendBom);
        sb.append(type_machine_id);
        sb.append("/");
        sb.append(use_power);
        sb.append("/");
        sb.append(forbid_power);
        sb.append("/");
        sb.append(chip_Id_list);
        sb.append("/");
        sb.append(glueId);
        sb.append("/");
        sb.append(scaffoldId);
        sb.append("/");
        sb.append(diffusionPowderId);
        sb.append("/");
        sb.append(antiStarchId);
        sb.append("/");
        if(limitPhosphorType.isEmpty()){
            sb.append(0);
        }else{
            sb.append(limitPhosphorType);
        }
        String url = sb.toString();
        System.out.println(url);
        String result = HttpUtil.HttpRequest(url);
        return result;
    }

    /**
     *在线推BOM接口
     * 调用条件
     * 1. 在制工单管理-在制详情，系统建议2，6
     * @param type 类型 0：没有要求，1：亮度不符，2：显指不符
     * @param use_power 必用荧光粉id 多个,分割 没有
     * @param forbid_power 禁用荧光粉id 多个,分割
     * @param task_id 任务单id
     * @param model_id 模型id
     * @param chip_wl_rank_id_list 芯片波段id
     * @param limitPhosphorType 允许使用的荧光粉类型
     *
     */
    public static String  updateBom(Integer type,String use_power,String forbid_power,Integer task_id,Integer model_id,String chip_wl_rank_id_list,String limitPhosphorType){
        StringBuffer sb = new StringBuffer(updateBom);
        sb.append(type);
        sb.append("/");
        sb.append(use_power);
        sb.append("/");
        sb.append(forbid_power);
        sb.append("/");
        sb.append(task_id);
        sb.append("/");
        sb.append(model_id);
        sb.append("/");
        sb.append(chip_wl_rank_id_list);
        sb.append("/");
        sb.append(limitPhosphorType);
        String result = HttpUtil.HttpRequest(sb.toString());
        return result;
    }

    /**
     * 带显指的配比推荐
     * 调用条件
     * 1. 配比库》生产搭配》查看详细 》系统推荐，选择相似模型后
     * 2. 在制工单管理》在制详情》 系统建议，优化配比
     * @param similar_model_id 模型ID（客户选择或默认） 生产过程中，不给 传0
     * @param model_id  需要推荐配比的模型ID，生产过程中 这个工单当时用的模型的ID
     * @param task_id 工单ID（客户选择或默认） 被选中的工单 生产过程中是本工单的ID
     * @param task_state_id 工单状态ID 配比库中调用，给0
     * @param recommend_model_id 需要推荐配比的模型ID
     * @param type 0:配比库中调用，1：生产过程调用
     * @param ra_require 忽不忽略显指 0：忽略，1：不忽略
     * -- 2020-06-01 修改
     */
    public static String recommendRatio(Integer model_id,Integer task_state_id,Integer type,Integer ra_require){
        StringBuffer sb = new StringBuffer(recommendRatio);
        sb.append("/");
        sb.append(model_id);
        sb.append("/");
        //sb.append(task_id);
        sb.append(task_state_id);
        /*sb.append("/");
        sb.append(recommend_model_id);*/
        sb.append("/");
        sb.append(type);
        sb.append("/");
        sb.append(ra_require);
        String result = HttpUtil.HttpRequest(sb.toString());
        return result;
    }



    /**
     * NG建议判断
     * 调用条件 在制工单管理》在制详情》 系统建议
     * @param task_id
     * @param taskStateId
     *
     */
    public static String ngProposeJudge(Integer taskStateId){
        StringBuffer sb = new StringBuffer(ngProposeJudge);
        sb.append("/");
        sb.append(taskStateId);
        String result = HttpUtil.HttpRequest(sb.toString());
        return result;
    }


    /**
     * 试配打点开始推荐
     * @param
     * @return
     */
    public static Result dadianRatioMethod(Integer modelId,Integer taskStateId,Integer raHOrL,Float raRatio,Float wt,String points){
        StringBuffer sb_specDecisionRule = new StringBuffer(getDadianRatio);
        sb_specDecisionRule.append("/");
        sb_specDecisionRule.append(modelId);
        sb_specDecisionRule.append("/");
        sb_specDecisionRule.append(taskStateId);
        sb_specDecisionRule.append("/");
        sb_specDecisionRule.append(raHOrL);
        sb_specDecisionRule.append("/");
        sb_specDecisionRule.append(raRatio);
        sb_specDecisionRule.append("/");
        sb_specDecisionRule.append(wt);
        sb_specDecisionRule.append("/");
        sb_specDecisionRule.append(points);
        String result = HttpUtil.HttpRequest(sb_specDecisionRule.toString());

        AiResut aiResut = JSON.parseObject(result,AiResut.class);

        //Result<AiDadainRatio> aiResutResult = new Result<>();
        Result aiResutResult = new Result<>();
        aiResutResult.setCode(aiResut.getCode());
        aiResutResult.setMessage(aiResut.getMsg());

        if(aiResut.getCode()==0){
            //aiResutResult.setData(aiResut.getData().toJavaObject(AiDadainRatio.class));
            aiResutResult.setData(aiResut.getData());
        }

        return aiResutResult;
    }

}
