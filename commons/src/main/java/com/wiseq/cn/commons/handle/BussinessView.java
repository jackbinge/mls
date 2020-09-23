package com.wiseq.cn.commons.handle;

import com.wiseq.cn.commons.entity.WebResultParm;

/**
 * 版本        修改时间        编者      备注
 * V1.0        ------        jpdong    原始版本
 * 文件说明:
 **/
public abstract class  BussinessView<T> {
    /**
     * 初始化
     */
    public abstract void viewInit();

    /**
     * 条件组装
     */
    public abstract WebResultParm viewAssemble();

    /**
     * Spark Task Submit
     */
    public abstract void viewRequest(WebResultParm webResultParm);

    /**
     * 消息接收
     */
    public abstract void messageReceive(WebResultParm webResultParm);

    /**
     * 数据处理
     */
    public abstract void dataReceive(WebResultParm webResultParm);

    /**
     * 等待
     */
    public abstract void viewWait(WebResultParm webResultParm, Thread t);

    /**
     * 销毁
     */
    public abstract void viewDestory(WebResultParm webResultParm, Thread t);
}
