package com.wiseq.cn.entity.ykAi;


import lombok.Data;

import java.util.Date;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/21     jiangbailing      原始版本
 * 文件说明: 工单状态表
 */
@Data
public class BsTaskState {

    private Long id;

    /**
     * 任务单id
     */

    private Long taskId;

    /**
     * 任务状态定义id
     */
    private Long taskDfId;

    /**
     * 是否重新测试，默认是false,不重新测试
     */

    private Boolean isRetest;

    /**
     * 当前状态对应的算法模型
     */

    private Long modelId;

    /**
     * 失败原因
     */

    private String reason;

    /**
     * 解决措施 成功为0, 1忽略继续生产  2修改点胶量 3修改配比 4 修改bom 5 前测数据批量否定
     */

    private Byte solutionType;

    /**
     * 创建时间
     */

    private Date createTime;

    /**
     * 修改时间
     */

    private Date modifyTime;

    /**
     * 当前是否处于活动状态
     */

    private Boolean isActive;

    /**
     * 当前登录用户
     */

    private Long creator;

    /**
     * 修改状态的用户
     */

    private Long updateUser;

    /**
     * 状态变更修改确认用户
     */

    private Long checkUser;

    /**
     * 前测规则ID
     */
    private Long outputRequireBeforeTestRuleId;

    /**
     * 非正常烤
     */
    private Long outputRequireNbakeRuleId;

    /**
     * 文件ID列表
     */
    private String fileidList;

}