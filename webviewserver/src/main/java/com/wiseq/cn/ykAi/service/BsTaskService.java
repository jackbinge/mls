package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.*;
import com.wiseq.cn.ykAi.service.servicefbk.BsTaskServiceFbk;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/24     jiangbailing      原始版本
 * 文件说明:
 */
@FeignClient(value = "mysqldata-service/BsTaskController", fallback = BsTaskServiceFbk.class)
public interface BsTaskService {

    @GetMapping("/InProductTaskList")
    @ApiOperation("获取在制工单管理列表")
    public Result InProductTaskList(@RequestParam(value = "taskCode",required = false) String taskCode,
                                    @RequestParam(value = "type",required = false)Byte type,
                                    @RequestParam(value = "groupId",required = false) Long groupId,
                                    @RequestParam(value = "typeMachineSpec",required = false) String typeMachineSpec,
                                    @RequestParam(value = "stateFlag",required = false) Byte stateFlag,
                                    @RequestParam(value = "pageNum")Integer pageNum,
                                    @RequestParam(value = "pageSize")Integer pageSize);


    /**
     * 获取工单最新的阀体列表
     * @param taskStateId
     * @return
     */
    @GetMapping("/findTaskStateEqptValve")
    @ApiOperation("获取工单最新的阀体列表")
    Result findTaskStateEqptValve(@RequestParam(value = "taskStateId") Long taskStateId);

    /**
     * 获取工单详情之页面的配比
     * @param taskId
     * @return
     */
    @GetMapping("/judgeTaskFormulaList")
    @ApiOperation("获取工单详情之页面的配比")
    Result judgeTaskFormulaList(@RequestParam(value = "taskStateId") Long taskStateId);

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
    @PutMapping("/closeTask")
    @ApiOperation("工单关闭操作")
    Result closeTask(@RequestParam(value = "taskStateId")Long taskStateId,
                     @RequestParam(value = "userId") Long userId);



    @PutMapping("/taskFormulaEdit")
    @ApiOperation("工单编辑")
    Result taskFormulaEdit(@RequestBody BsTaskFormulaForPage bsTaskFormulaForPage);

    @PostMapping("/updateUseAdviceFormulaEdit")
    @ApiOperation("试配打点工单编辑")
    Result updateUseAdviceFormulaEdit(@RequestBody BsTaskFormulaForPage bsTaskFormulaForPage);

    /**
     * 获取可供选择的阀体
     * @param positon
     * @return
     */
    @GetMapping("/getListOfOptionsEqptValve")
    @ApiOperation("获取可供选择的阀体")
    Result  getListOfOptionsEqptValve(@RequestParam(value = "positon",required = false) Integer positon);


    @PutMapping("/beginSY")
    @ApiOperation("开始试样")
    Result beginSY(@RequestParam(value = "taskStateId")Long taskStateId,
                   @RequestParam(value = "userId")Long userId);




    @PutMapping("/setNG")
    @ApiOperation("设置NG--2.0（新加参数：judgementResult）")
    Result setNG(@RequestParam(value = "taskStateId")Long taskStateId,
                 @RequestParam(value = "eqptValveId") Long eqptValveId,
                 @RequestParam(value = "userId") Long userId,
                 @RequestParam(value = "judgementResult") String judgementResult);


    @PutMapping("/cancelNG")
    @ApiOperation("取消NG[改参数][加参数]")
    Result cancelNG(@RequestParam(value = "taskStateId")Long taskStateId,
                    @RequestParam(value = "eqptValveIdList")String eqptValveIdList,
                    @RequestParam(value = "userId") Long userId,
                    @ApiParam(name = "raRequire",value = "是否忽略显示要求,0忽略，1不忽略")
                    @RequestParam(value = "raRequire",required = false,defaultValue = "1")Integer raRequire,
                    @RequestParam(value = "compulsoryPass",required = false,defaultValue = "0") Integer compulsoryPass,
                    @RequestParam(value = "updateChipArea",required = false,defaultValue = "0") Integer updateChipArea);



    @PutMapping("/testOk")
    @ApiOperation("测试OK")
    Result testOk(@RequestParam(value = "taskStateId")Long taskStateId,
                  @RequestParam(value = "eqptValveId")Long eqptValveId,
                  @RequestParam(value = "userId")Long userId);


    @PutMapping("/discard")
    @ApiOperation("重新测试")
    Result allDiscard(@RequestParam(value = "taskStateId")Long taskStateId,
                      @RequestParam(value = "fileId",required = false)Long fileId,
                      @RequestParam(value = "userId")Long userId,
                      @RequestParam(value = "eqptValveId")Long eqptValveId);


    @GetMapping("/getTaskDtl")
    @ApiOperation("获取工单详情")
    Result getTaskDtl(@RequestParam(value = "taskStateId")Long taskStateId);


    @PostMapping("/addFormula")
    @ApiOperation("配比新增")
    Result addFormulaEdit(@RequestBody EditTaskFormulaForPage editTaskFormulaForPage);


    @PostMapping("/addTaskEqptValve")
    @ApiOperation("新增阀体和点胶设定参数")
    Result addTaskEqptValve(@RequestBody List<BsEqptGuleDosage> list);


    @PutMapping("/closeTaskEqptValve")
    @ApiOperation("关闭阀体")
    Result closeTaskEqptValve(@RequestBody EqptValveClose eqptValveClose);


    @PutMapping("/setEqptGlueDosage")
    @ApiOperation("修改阀体点胶参数")
    Result setEqptGlueDosage(@RequestBody BsEqptValveDosageEadit bsEqptValveDosageEadit);

    @PostMapping("/editTaskAIModel")
    @ApiOperation("修改工单生产搭配的BOM")
    Result editTaskAIModel(@RequestBody BsTaskAIModelEdit bsTaskAIModelEdit);


    @GetMapping("/recommendGlueDosage")
    @ApiOperation("修改工单生产搭配的BOM")
    Result recommendGlueDosageMethod(@RequestParam("eqptValveId")Long eqptValveId,@RequestParam("taskStateId") Long taskStateId);


    @PutMapping("/goToLC")
    @ApiOperation("进入量产")
    Result  goToLC(@RequestParam("taskId")Long taskId,
                   @RequestParam("taskStateId")Long taskStateId,
                   @RequestParam("userId")Long userId);


    @GetMapping("/aiModelCustom")
    @ApiOperation("配比库中新荐配比，更新模型系数,用户选择数据源后调用")
    Result aiModelCustom(//@RequestParam(value = "selectModelId") Long selectModelId,
                         //@RequestParam(value = "selectTaskId")Long selectTaskId,
                         @RequestParam(value = "thisModelId")Long thisModelId,
                         //@RequestParam(value = "thisTaskId",required = false) Long thisTaskId,
                         @RequestParam(value = "taskStateId",required = false)Long taskStateId,
                         @RequestParam(value = "userId") Long userId);


    @GetMapping("/aiRecommendModelList")
    @ApiOperation("配比推荐数据源之模型列表")
    Result aiRecommendModelList( @RequestParam(value = "modelId") Long modelId,
                                 @RequestParam(value = "typeMachineSpec",required = false) String typeMachineSpec,
                                 @RequestParam(value = "tOutputCode",required = false) String tOutputCode,
                                 @RequestParam(value = "bomCode",required = false) String bomCode,
                                 @RequestParam(value = "pageNum") Integer pageNum,
                                 @RequestParam(value = "pageSize") Integer pageSize);


    @GetMapping("/findAiRecommendTaskList")
    @ApiOperation("配比推荐数据源之模型对应的工单列表")
    public Result findAiRecommendTaskList(@RequestParam(value = "taskCode",required = false) String taskCode,
                                          @RequestParam(value = "groupId",required = false) Long groupId,
                                          @RequestParam(value = "taskType",required = false) Byte taskType,
                                          @RequestParam(value = "selectModelId") Long selectModelId,
                                          @RequestParam(value = "pageNum") Integer pageNum,
                                          @RequestParam(value = "pageSize") Integer pageSize);

    @PutMapping("/aiUpdateModel")
    @ApiOperation("系统修正配比")
    public Result aiUpdateModel(@RequestParam(value = "taskId")Long taskId,
                                @RequestParam(value = "taskStateId")Long taskStateId,
                                @RequestParam(value = "userId")Long userId,
                                @RequestParam(value = "raRequire")
                                @ApiParam(name = "raRequire",value = "忽不忽略显指,0：忽略，1：不忽略",required = true) Integer raRequire);

    @PutMapping("/aiTaskFormulaForFile")
    @ApiOperation("系统通过上传的分光文件决定是否修正配比")
    Result aiTaskFormulaForFile(@RequestParam(value = "fileId") Long fileId);


    @GetMapping("/findTaskListByTypeModelId")
    @ApiOperation("机种-获取生产记录")
    Result findTaskListByTypeModelId(@RequestParam(value = "modelId")Long modelId);

    @GetMapping("/checkoutAiModel")
    @ApiOperation("验证当前工单作用bom是否合理-2.0")
    Result checkoutAiModel(@RequestParam(value = "taskStateId")Long taskStateId);


    @GetMapping("/systemAdvice")
    @ApiOperation("系统建议列表-2.0")
    Result systemAdvice(@RequestParam(value = "taskStateId")Long taskStateId);


    @GetMapping("getjudgementType")
    @ApiOperation("获取上传-2.0")
    Result getjudgementType(@RequestParam(value = "taskStateId")Long taskStateId);

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
    @ApiOperation("获取已经关闭的住流程工单-2.0")
    Result getCloseMainProcessTask(@RequestParam(value = "taskCode",required = false) String taskCode,
                                   @RequestParam(value = "type",required = false) Byte type,
                                   @RequestParam(value = "groupId",required = false) Long groupId,
                                   @RequestParam(value = "typeMachineSpec",required = false) String typeMachineSpec,
                                   @RequestParam(value = "stateFlag",required = false) Byte stateFlag,
                                   @RequestParam(value = "pageNum")Integer pageNum,
                                   @RequestParam(value = "pageSize") Integer pageSize);

    @GetMapping("getNewestTaskStateId")
    @ApiOperation("获取这个流程对应的最新的taskStateId")
    Result getNewestTaskStateId(@RequestParam(value = "processType") Integer processType,
                                @RequestParam(value = "processVersion") Integer processVersion,
                                @RequestParam(value = "taskId")Long taskId);

    @PostMapping("getFilterBOMList")
    @ApiOperation("获取过滤后的BOM列表")
    Result getFilterBOMList(@RequestBody FilterBOMDataForPage filterBOMDataForPage);


    @GetMapping("getjudagementTypeByFileId")
    @ApiOperation("获取上传文件后需要展示的判定类型文件ID-2.0")
    Result getjudagementTypeByFileId(@RequestParam(value = "fileId")Long fileId);

    @PostMapping("/saveMixPowderWeight")
    @ApiOperation("临时保存配粉重量(每次保存修改当前数据覆盖上一次，没有新增)")
    Result  saveMixPowderWeight(@RequestBody ZConsumption zConsumption);

    @GetMapping("/getMixPowderWeight")
    @ApiOperation("查询配粉重量")
    Result getMixPowderWeight(@RequestParam(value = "taskId")Long taskId,@RequestParam(value = "taskStateId")Long taskStateId);

    @PostMapping("/getSpAdvice")
    @ApiOperation("开始推荐(试配打点)")
    Result getSpAdvice(@RequestBody StartAdvice startAdvice);
}
