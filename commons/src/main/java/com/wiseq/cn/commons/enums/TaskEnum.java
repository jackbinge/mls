package com.wiseq.cn.commons.enums;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/18     jiangbailing      原始版本
 * 文件说明:
 */
public enum TaskEnum {

    TaskPendingSample(1l,"待试样"),
    TaskSamplePreTest(2l,"试样前测中"),
    TaskSamplePreTestNG(3l,"试样前测NG"),
    TaskSamplePreTestOK(4l,"试样前测通过"),
    TaskSampleQualityTestNG(5l,"试样品质测试NG"),
    TaskBatchProduction(6l,"批量生产"),
    TaskBatchProductionValveNG(7l,"批量生产阀体NG"),
    TASKCLOSE(8l,"工单关闭"),
    TestProcessOK(9l,"打样通过"),
    TestProcessNg(10l,"打样失败");

    private Long stateFlag;
    private String stateName;

    TaskEnum(Long stateFlag, String stateName) {
        this.stateFlag = stateFlag;
        this.stateName = stateName;
    }


    public Long getStateFlag() {
        return stateFlag;
    }

    public String getStateName() {
        return stateName;
    }


    public static TaskEnum stateFlagOf(Long index) {
        for (TaskEnum stateFlag : values()) {
            if (stateFlag.stateFlag==index) {
                return stateFlag;
            }
        }
        return null;
    }

    public static void main(String[] args) {
        System.out.println(TaskEnum.TASKCLOSE.stateFlag);
        System.out.println(TaskEnum.TASKCLOSE.stateName);
        System.out.println(TaskEnum.TASKCLOSE);
        System.out.println(TaskEnum.stateFlagOf(1l).stateName);
    }
}
