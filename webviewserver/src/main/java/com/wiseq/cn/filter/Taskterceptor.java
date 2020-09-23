package com.wiseq.cn.filter;



import com.sun.jmx.snmp.tasks.TaskServer;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.NumberUtil;
import com.wiseq.cn.utils.MyResponseUtil;
import com.wiseq.cn.ykAi.service.BsTaskStateService;
import com.wiseq.cn.ykAi.service.TestService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpSession;


/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/19     jiangbailing      原始版本
 * 文件说明: 工单拦截器
 */
public class Taskterceptor implements HandlerInterceptor {

    public static final Logger log = LoggerFactory.getLogger(Taskterceptor.class);

    @Autowired
    private BsTaskStateService bsTaskStateService;

    @Override
    public boolean preHandle(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response, java.lang.Object handler) throws java.lang.Exception
    { log.info("Taskterceptor.preHandle");
        log.info("工单状态拦截器");
        //如果是SpringMVC请求
        if (handler instanceof HandlerMethod) {
            HandlerMethod handlerMethod = (HandlerMethod) handler;
            log.info("当前拦截的方法为：{}", handlerMethod.getMethod().getName());
            log.info("当前拦截的方法参数长度为：{}", handlerMethod.getMethod().getParameters().length);
            log.info("当前拦截的类为：{}", handlerMethod.getBean().getClass().getName());
            String uri = request.getRequestURI();
            log.info("拦截的uri：" + uri);
        }
        String strTaskId = request.getHeader("taskId");
        String strTaskState = request.getHeader("taskStateId");
        if(null != strTaskId && !"".equals(strTaskId)){
            log.info("工单ID为:"+strTaskId);
            Long taskId = Long.parseLong(strTaskId);
            Long taskStateId = Long.parseLong(strTaskState);
            Result result = bsTaskStateService.getActiveTaskState(taskId,taskStateId);
            if(result.getCode()==0){
                return true;
            }else if(result.getCode()!=0){
                MyResponseUtil.responseOutWithJson(response,result);
                return false;
            }
        }else {
            return true;
        }

        return  true;
    }

    @Override
    public void postHandle(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response, java.lang.Object handler, @org.springframework.lang.Nullable org.springframework.web.servlet.ModelAndView modelAndView) throws java.lang.Exception
    { /* compiled code */ }

    @Override
    public void afterCompletion(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response, java.lang.Object handler, @org.springframework.lang.Nullable java.lang.Exception ex) throws java.lang.Exception
    { /* compiled code */ }
}
