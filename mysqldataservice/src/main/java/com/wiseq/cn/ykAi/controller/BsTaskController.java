package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.*;
import com.wiseq.cn.ykAi.service.BsTaskService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/21     jiangbailing      原始版本
 * 文件说明:
 */
@RestController
@RequestMapping("/BsTaskController")
@Api(description = "工单管理")
public class BsTaskController {
    @Autowired
    private BsTaskService bsTaskService;

    /**
     *
     * @param taskCode
     * @param type
     * @param groupId
     * @param typeMachineSpec
     * @param stateFlag
     * @param pageNum
     * @param pageSize
     * @return
     * -- 2020-05-23
     *  --改动 只查询主流程工单
     */
    @GetMapping("/InProductTaskList")
    @ApiOperation("获取在制工单管理列表")
    public Result InProductTaskList(@RequestParam(value = "taskCode",required = false) String taskCode,
                                    @RequestParam(value = "type",required = false)Byte type,
                                    @RequestParam(value = "groupId",required = false) Long groupId,
                                    @RequestParam(value = "typeMachineSpec",required = false) String typeMachineSpec,
                                    @RequestParam(value = "stateFlag",required = false) Byte stateFlag,
                                    @RequestParam(value = "pageNum")Integer pageNum,
                                    @RequestParam(value = "pageSize")Integer pageSize){
        return this.bsTaskService.InProductTaskList(taskCode, type, groupId, typeMachineSpec, stateFlag, pageNum, pageSize);
    }


    /**
     * 获取工单最新的阀体列表
     * @param taskStateId
     * @return
     * -- 2020-05-23
     *  --改动:   参数 taskId -> taskStateId
     */
    @GetMapping("/findTaskStateEqptValve")
    @ApiOperation("获取工单最新的阀体列表")
    Result findTaskStateEqptValve(@RequestParam(value = "taskStateId") Long taskStateId){
        return this.bsTaskService.findTaskStateEqptValve(taskStateId);
    }


    /**
     * 获取工单详情之页面的配比
     * @param taskStateId
     * @return
     * -- 2020-05-23
     *  --改动:   参数 taskId -> taskStateId
     *  --查询的时候不仅是查询也有绑定
     */
    @GetMapping("/judgeTaskFormulaList")
    @ApiOperation("获取工单详情之页面的配比")
    Result judgeTaskFormulaList(@RequestParam(value = "taskStateId") Long taskStateId){
        return this.bsTaskService.judgeTaskFormulaList(taskStateId);
    }


    /**
     * 工单关闭操作
     * 首先获取当前工单的状态数据
     * 1.新增工单状态表，修改工单状态表原来的数据
     * 2.工单关闭 设置为关闭 ，更新关闭时间bs_task
     * 3.复制阀体把阀体状体状态改为已关闭 bs_eqpt_valve_state
     * 4.删除阀体工单对应表里面的数据和此工单对应的数据bs_eqpt_task_runtime
     * 5.工单状态对阀体表设为已关闭
     * -- 2020-05-23
     *    -- 改动：此关闭只考虑主流程工单
     *    -- 参数 taskId -> taskStateId
     */
    @Transactional
    @PutMapping("/closeTask")
    @ApiOperation("工单关闭操作")
    Result closeTask(@RequestParam(value = "taskStateId")Long taskStateId,
                     @RequestParam(value = "userId") Long userId){
        return this.bsTaskService.closeTask(taskStateId, userId);
    }


    /**
     *
     * @param bsTaskFormulaForPage
     * @return
     * -- 2020-05-23
     *    -- 改动：不用taskId 而用taksStateId
     *    -- 考虑阀体继承问题
     *    -- 考虑主流程和打样流程
     *    -- 无论是不是待生产阶段都要保存配比
     */
    @Transactional
    @PutMapping("/taskFormulaEdit")
    @ApiOperation("工单配比编辑修改配比")
    Result taskFormulaEdit(@RequestBody BsTaskFormulaForPage bsTaskFormulaForPage){
        return this.bsTaskService.taskFormulaEdit(bsTaskFormulaForPage);
    }


    /**
     *
     * @param bsTaskFormulaForPage
     * @return
     * -- 2020-09-8
     *    -- 改动：不用taskId 而用taksStateId
     *    -- 考虑阀体继承问题
     *    -- 考虑主流程和打样流程
     *    -- 无论是不是待生产阶段都要保存配比
     */
    @Transactional
    @PostMapping("/updateUseAdviceFormulaEdit")
    @ApiOperation("使用推荐配比编辑修改配比")
    Result updateUseAdviceFormulaEdit(@RequestBody BsTaskFormulaForPage bsTaskFormulaForPage){
        return this.bsTaskService.updateUseAdviceFormulaEdit(bsTaskFormulaForPage);
    }




    /**
     * 获取可供选择的阀体
     * @param positon
     * @return
     */
    @GetMapping("/getListOfOptionsEqptValve")
    @ApiOperation("获取可供选择的阀体")
    Result  getListOfOptionsEqptValve(@RequestParam(value = "positon",required = false) Integer positon){
        return this.bsTaskService.getListOfOptionsEqptValve(positon);
    }

    /**
     *
     * @param taskId
     * @param userId
     * @return
     * ----2020-05-23 修改点
     *      -- 参数 taskId -> taskStateId
     *      -- 开始试样时应该只进行状态变更没有 判断配比库配比 和 当前配比绑定的环节
     *
     */
    @Transactional
    @PutMapping("/beginSY")
    @ApiOperation("开始试样")
    Result beginSY(@RequestParam(value = "taskStateId")Long taskStateId,
                   @RequestParam(value = "userId")Long userId){
        return this.bsTaskService.beginSY(taskStateId, userId);
    }

    /**
     *
     * @param taskId
     * @param taskStateId
     * @param eqptValveId
     * @param userId
     * @param judgementResult
     * @return
     *  --- 2020-05-26 新需求 改动
     *      -- 修改  setNG 调用的 testOK 方法
     *      -- 修改 参数 taskId -> taskStateId
     */
    @Transactional
    @PutMapping("/setNG")
    @ApiOperation("设置NG--2.0（新加参数：judgementResult）")
    Result setNG(@RequestParam(value = "taskStateId")Long taskStateId,
                 @RequestParam(value = "eqptValveId") Long eqptValveId,
                 @RequestParam(value = "userId") Long userId,
                 @RequestParam(value = "judgementResult") String judgementResult){
        return this.bsTaskService.setNG(taskStateId, eqptValveId, userId,judgementResult);
    }


    /**
     *
     * @param taskId
     * @param taskStateId
     * @param eqptValveIdList
     * @param userId
     * @param raRequire
     * @param compulsoryPass
     * @return
     *  -- 2020-05-26 修改 新增 compulsoryPass 是否强制通过，updateChipArea 修改芯片发光面积
     *                  -- 新增字段的判定 和 打样流程的状态变更都加上了
     *                  -- 忽略rar9时要把新的工单状态 raR9要求也修改
     */
    @Transactional
    @PutMapping("/cancelNG")
    @ApiOperation("取消NG")
    Result cancelNG(@RequestParam(value = "taskStateId")Long taskStateId,
                    @RequestParam(value = "eqptValveIdList")String eqptValveIdList,
                    @RequestParam(value = "userId") Long userId,
                    @ApiParam(name = "raRequire",value = "是否忽略显示要求,0忽略，1不忽略")
                    @RequestParam(value = "raRequire",required = false,defaultValue = "1")Integer raRequire,
                    @RequestParam(value = "compulsoryPass",required = false,defaultValue = "0") Integer compulsoryPass,
                    @RequestParam(value = "updateChipArea",required = false,defaultValue = "0") Integer updateChipArea){

       if(eqptValveIdList.length()==0){
           return ResultUtils.error(1,"没有阀体列表");
       }
       List<Long> arrayStrList = stringToLongList(eqptValveIdList);
       return this.bsTaskService.cancelNG(taskStateId, arrayStrList, userId,raRequire,compulsoryPass,updateChipArea);

    }

    //去重
    private List<Long> stringToLongList(String strArr) {
        return Arrays.stream(strArr.split(","))
                .map(s -> Long.parseLong(s.trim())).distinct()
                .collect(Collectors.toList());
    }

    /**
     * @param taskId
     * @param taskStateId
     * @param eqptValveId
     * @param userId
     * @return
     * --- 2020-05-27 修改（废弃）
     *     -- 参数taskId 改为 taskStateId
     *     -- 此接口不再为前端使用
     *
     */
    @Transactional
    @PutMapping("/testOk")
    @ApiOperation("测试OK -- 2.0 废弃不对前端开放所有都走setNG接口")
    Result testOk(@RequestParam(value = "taskStateId")Long taskStateId,
                  @RequestParam(value = "eqptValveId")Long eqptValveId,
                  @RequestParam(value = "userId")Long userId){
        return this.bsTaskService.testOk(taskStateId, eqptValveId, userId);
    }

    /**
     *
     * @param taskId
     * @param fileId
     * @param userId
     * @param eqptValveId
     * @return
     * -- 2020-05-27  修改点
     *      -- 参数 taskId -> taskStateId
     *      -- 重新测试不再进行工单状态的变更
     *      -- 只是把文件设定为删除状态
     */
    @Transactional
    @PutMapping("/discard")
    @ApiOperation("重新测试")
    Result allDiscard(
                      @RequestParam(value = "taskStateId")Long taskStateId,
                      @RequestParam(value = "fileId",required = false)Long fileId,
                      @RequestParam(value = "userId")Long userId,
                      @RequestParam(value = "eqptValveId")Long eqptValveId){
        return this.bsTaskService.allDiscard(taskStateId, fileId, userId, eqptValveId);
    }


    /**
     * @param taskId
     * @param taskStateId
     * @return
     * -- 2020-05-27 修改
     *    -- taskId -> taskStateId
     *    -- 获取工单详情只限主流程的工单
     */
    @GetMapping("/getTaskDtl")
    @ApiOperation("获取工单详情")
    Result getTaskDtl(@RequestParam(value = "taskStateId")Long taskStateId){
        return this.bsTaskService.getTaskDtl(taskStateId);
    }


    /**
     *
     * @param editTaskFormulaForPage
     * @return
     *  -- 2020-05-27 修改
     *    -- 配比新增分为 1.配比库中新增 2.工单中新增
     *    -- 要在工单状体表中维护配比相关的字段数据
     */
    @PostMapping("/addFormula")
    @ApiOperation("配比新增")
    Result addFormulaEdit(@RequestBody EditTaskFormulaForPage editTaskFormulaForPage){
        return this.bsTaskService.addTaskFormulaForPage(editTaskFormulaForPage);
    }


    /**
     *
     * @param list
     * @return
     *  --- 2020-05-27 修改
     *      -- 以taskStateId 参数为主
     *      -- 覆盖打样流程的情况
     */
    @PostMapping("/addTaskEqptValve")
    @ApiOperation("新增阀体和点胶设定参数")
    @Transactional
    Result addTaskEqptValve(@RequestBody List<BsEqptGuleDosage> list){
        return this.bsTaskService.addTaskEqptValve(list);
    }


    /**
     *
     * @param eqptValveClose
     * @return
     *       -- 2020-05-27 修改（完毕）
     *       -- 主流程和打样流程区分
     *
     */
    @PutMapping("/closeTaskEqptValve")
    @ApiOperation("关闭阀体")
    @Transactional
    Result closeTaskEqptValve(@RequestBody EqptValveClose eqptValveClose){
        return this.bsTaskService.closeTaskEqptValve(eqptValveClose);
    }


    /**
     *
     * @param bsEqptValveDosageEadit
     * @return
     *  --- 2020-05-27 修改
     *      -- 以taskStateId 参数为主
     *      -- 覆盖打样流程的情况
     *
     */
    @PutMapping("/setEqptGlueDosage")
    @ApiOperation("修改阀体点胶参数")
    @Transactional
    Result setEqptGlueDosage(@RequestBody BsEqptValveDosageEadit bsEqptValveDosageEadit){
        return this.bsTaskService.setEqptGlueDosage(bsEqptValveDosageEadit);
    }


    /**
     *
     * @param bsTaskAIModelEdit
     * @return
     * --- 2020-05-27 修改
     *      -- 所有的数据变动以taskStateId 为主
     *      -- 修改配方时维护bs_task_state表中与配方相关的字段，把其记录到新的状态数据
     *      -- 如果有此配方关联的配比 则维护配比相关字段，并且和新的状态数据关联起来
     *      -- 增加阀体继承功能
     */
    @PostMapping("/editTaskAIModel")
    @ApiOperation("修改工单生产搭配的BOM，修改配方")
    @Transactional
    Result editTaskAIModel(@RequestBody BsTaskAIModelEdit bsTaskAIModelEdit){
        return this.bsTaskService.editTaskAIModel(bsTaskAIModelEdit);
    }


    /**
     *
     * @param eqptValveId
     * @param taskId
     * @param taskStateId
     * @return
     *  --- 2020-05-27 修改
     *      -- 参数 taskId -> taskStateId
     */
    @GetMapping("/recommendGlueDosage")
    @ApiOperation("推荐点胶量")
    Result recommendGlueDosageMethod(@RequestParam("eqptValveId") Long eqptValveId,@RequestParam("taskStateId") Long taskStateId){
        return this.bsTaskService.recommendGlueDosageMethod(eqptValveId,taskStateId);
    }


    /**
     *
     * @param taskId
     * @param taskStateId
     * @param userId
     * @return
     *  --- 2020-05-27 修改
     *      -- 以taskStatId 为主 覆盖打样流程
     */
    @PutMapping("/goToLC")
    @ApiOperation("进入量产")
    Result  goToLC(@RequestParam("taskId")Long taskId,
                   @RequestParam("taskStateId")Long taskStateId,
                   @RequestParam("userId")Long userId){
        return this.bsTaskService.goToLC(taskId, taskStateId, userId);
    }


    /**
     * 离线推配比分为工单离线推（此工单对应的配方还没有配比时），配比库中推配比
     * @param selectModelId
     * @param selectTaskId
     * @param thisModelId
     * @param thisTaskId
     * @param taskStateId
     * @param userId
     * @return
     * --- 2020-06-01 修改
     *   -- 对应新算法修改参数
     *   -- 如果是在工单页面的离线推配比 - 要维护这个工单状态的配比数据
     *   -- 注意：此时这个配方是没有任何配比的，不论在工单页面还是在配比库中
     *
     */
    @GetMapping("/aiModelCustom")
    //@ApiOperation("离线新荐配比，1.工单配方没配比，2.配比库中推荐配比 更新模型系数,用户选择数据源后调用--2.0后台有改动")
    Result aiModelCustom(@RequestParam(value = "thisModelId")Long thisModelId,
                         @RequestParam(value = "taskStateId",required = false)Long taskStateId,
                         @RequestParam(value = "userId") Long userId){
        return  this.bsTaskService.aiModelCustom(thisModelId,taskStateId,userId);
    }


    /**
     *
     * @param modelId
     * @param typeMachineSpec
     * @param tOutputCode
     * @param bomCode
     * @param pageNum
     * @param pageSize
     * @return
     * --- 2020-06-01 接口废除
     *     -- 算法在后台直接筛选最优数据源，不用用户去选择数据源
     */
    @GetMapping("/aiRecommendModelList")
    @ApiOperation("配比推荐数据源之模型列表")
    Result aiRecommendModelList( @RequestParam(value = "modelId") Long modelId,
                                 @RequestParam(value = "typeMachineSpec",required = false) String typeMachineSpec,
                                 @RequestParam(value = "tOutputCode",required = false) String tOutputCode,
                                 @RequestParam(value = "bomCode",required = false) String bomCode,
                                 @RequestParam(value = "pageNum") Integer pageNum,
                                 @RequestParam(value = "pageSize") Integer pageSize){
        return this.bsTaskService.aiRecommendModelList(modelId, typeMachineSpec, tOutputCode, bomCode, pageNum, pageSize);
    }


    /**
     *
     * @param taskCode
     * @param groupId
     * @param taskType
     * @param selectModelId
     * @param pageNum
     * @param pageSize
     * @return
     * --- 2020-06-01 接口废除
     *      -- 算法在后台直接筛选最优数据源，不用用户去选择数据源
     */
    @GetMapping("/findAiRecommendTaskList")
    @ApiOperation("配比推荐数据源之模型对应的工单列表")
    public Result findAiRecommendTaskList(@RequestParam(value = "taskCode",required = false) String taskCode,
                                          @RequestParam(value = "groupId",required = false) Long groupId,
                                          @RequestParam(value = "taskType",required = false) Byte taskType,
                                          @RequestParam(value = "selectModelId") Long selectModelId,
                                          @RequestParam(value = "pageNum") Integer pageNum,
                                          @RequestParam(value = "pageSize") Integer pageSize){
        return this.bsTaskService.findAiRecommendTaskList(taskCode, groupId, taskType, selectModelId, pageNum, pageSize);

    }

    /**
     *
     * @param taskId
     * @param taskStateId
     * @param userId
     * @param raRequire
     * @return
     * ---  2020-06-01 修改
     *      -- 主要使用taskStateId 这个参数，因为存在打样流程的缘故
     *      -- 算法对接的接口有变动，传的参数不同
     *      -- raR9要求得更改方式不同了
     *      -- 新增阀体继承功能
     */
    @PutMapping("/aiUpdateModel")
    @ApiOperation("系统修正配比--2.0 新加参数(吃完改，要記錄是否忽略)")
    public Result aiUpdateModel(@RequestParam(value = "taskId")Long taskId,
                                @RequestParam(value = "taskStateId")Long taskStateId,
                                @RequestParam(value = "userId")Long userId,
                                @RequestParam(value = "raRequire")
                                @ApiParam(name = "raRequire",value = "忽不忽略显指,0：忽略，1：不忽略") Integer raRequire){

        return this.bsTaskService.aiUpdateModel(taskId, taskStateId, userId,raRequire);
    }

    /**
     *
     * @param modelId
     * @return
     * -- 2020-05-28 修改
     *    -- 只限主流程的工单
     */
    @GetMapping("/findTaskListByTypeModelId")
    @ApiOperation("机种-获取生产记录")
    Result findTaskListByTypeModelId(@RequestParam(value = "modelId")Long modelId){
        return this.bsTaskService.findTaskListByTypeModelId(modelId);
    }
//    @PutMapping("/aiTaskFormulaForFile")
//    @ApiOperation("系统通过上传的分光文件决定是否修正配比")
//    Result aiTaskFormulaForFile(@RequestParam(value = "fileId") Long fileId){
//        return this.bsTaskService.aiTaskFormulaForFile(fileId);
//    }

    /**
     *
     * @param taskId
     * @param taskStateId
     * @return
     * -- 2020-05-28 修改
     *          -- 参数 taskId -> taskStateId
     */
    @GetMapping("/checkoutAiModel")
    @ApiOperation("验证当前工单作用bom是否合理-2.0")
    Result checkoutAiModel(@RequestParam(value = "taskStateId")Long taskStateId){
        return this.bsTaskService.checkoutAiModel(taskStateId);
    }

    /**
     *
     * @param taskId
     * @param taskStateId
     * @return
     * -- 2020-06-01 修改
     *    --参数 - taskId -> taskStateId
     *    --算法对接参数 taskId -> taskStateId
     *    -- 兼顾打样流程
     *
     */
    @GetMapping("/systemAdvice")
    @ApiOperation("系统建议列表-2.0")
    Result systemAdvice(@RequestParam(value = "taskStateId")Long taskStateId){
        return this.bsTaskService.systemAdvice(taskStateId);
    }

    /**
     *
     * @param taskId
     * @param taskStateId
     * @return
     * -- 2020-05-28 修改
     *    -- 参数 taskId -> taskStateId
     *    -- 同样适用于打样流程
     */
    @GetMapping("getjudgementType")
    @ApiOperation("获取上传文件后需要展示的判定类型-2.0")
    Result getjudgementType(@RequestParam(value = "taskStateId")Long taskStateId){
        return this.bsTaskService.getjudgementType(taskStateId);
    }



    /**
     *
     * @param taskCode
     * @param type
     * @param groupId
     * @param typeMachineSpec
     * @param stateFlag
     * @param pageNum
     * @param pageSize
     * @return
     * -- 2020-06-03 新增接口
     */
    @GetMapping("getCloseMainProcessTask")
    @ApiOperation("获取已经关闭的主流程工单-2.0")
    Result getCloseMainProcessTask(@RequestParam(value = "taskCode",required = false) String taskCode,
                                   @RequestParam(value = "type",required = false) Byte type,
                                   @RequestParam(value = "groupId",required = false) Long groupId,
                                   @RequestParam(value = "typeMachineSpec",required = false) String typeMachineSpec,
                                   @RequestParam(value = "stateFlag",required = false) Byte stateFlag,
                                   @RequestParam(value = "pageNum")Integer pageNum,
                                   @RequestParam(value = "pageSize") Integer pageSize){
        return this.bsTaskService.getCloseMainProcessTask(taskCode, type, groupId, typeMachineSpec, stateFlag, pageNum, pageSize);
    }

    @GetMapping("getNewestTaskStateId")
    @ApiOperation("获取这个流程对应的最新的taskStateId")
    Result getNewestTaskStateId(@RequestParam(value = "processType") Integer processType,
                                 @RequestParam(value = "processVersion") Integer processVersion,
                                 @RequestParam(value = "taskId")Long taskId){
        return this.bsTaskService.getNewestTaskStateId(processType,processVersion,taskId);
    }


    @PostMapping("getFilterBOMList")
    @ApiOperation("获取过滤后的BOM列表")
    Result getFilterBOMList(@RequestBody FilterBOMDataForPage filterBOMDataForPage){
        return this.bsTaskService.getFilterBOMList(filterBOMDataForPage);
    }

    @GetMapping("getjudagementTypeByFileId")
    @ApiOperation("获取上传文件后需要展示的判定类型文件ID-2.0")
    Result getjudagementTypeByFileId(@RequestParam(value = "fileId")Long fileId){
        return bsTaskService.getjudagementTypeByFileId(fileId);
    }

    /*
    @GetMapping("/getConsumption")
    @ApiOperation("获得耗用")
    Result  getConsumption(@RequestParam(value = "taskStateId") Long taskStateId){
        return bsTaskService.getConsumption(taskStateId);
    }
*/
    @PostMapping("/saveMixPowderWeight")
    @ApiOperation("临时保存配粉重量(每次保存修改当前数据覆盖上一次，没有新增)")
    @Transactional
    Result  saveMixPowderWeight(@RequestBody ZConsumption zConsumption){

        return this.bsTaskService.saveMixPowderWeight(zConsumption);
    }

    @GetMapping("/getMixPowderWeight")
    @ApiOperation("查询配粉重量")
    Result getMixPowderWeight(@RequestParam(value = "taskId")Long taskId,@RequestParam(value = "taskStateId")Long taskStateId){
        return bsTaskService.getMixPowderWeight(taskId,taskStateId);
    }

/*
    @PostMapping("/saveMixPowderWeight")
    @ApiOperation("打点配比推荐()")
    @Transactional
    Result  aa(@RequestBody ZConsumption zConsumption){

        return this.bsTaskService.saveMixPowderWeight(zConsumption);
    }
*/
    /**
     *
     * @param modelId        需要推荐配比的模型ID
     * @param taskStateId    对应工单状态
     * @param raHOrL    显指偏高还是偏低   0 适中，1偏高，2偏低
     * @param raRatio    显指调整比例
     * @param wt    微调
     * @param points    打点坐标   以-组合成字符串发给我
     * @return
     * -- 2020-09-07 修改
     *    试配打点开始推荐功能
     *
     *
     *
     */
    @PostMapping("/getSpAdvice")
    @ApiOperation("开始推荐(试配打点)")
    Result getSpAdvice(@RequestBody StartAdvice startAdvice){
        return this.bsTaskService.getSpAdvice(startAdvice);
    }



}
