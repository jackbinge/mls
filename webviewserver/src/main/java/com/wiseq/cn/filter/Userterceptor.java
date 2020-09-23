package com.wiseq.cn.filter;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.utils.MyResponseUtil;
import com.wiseq.cn.ykAi.service.TUserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/12/6     jiangbailing      原始版本
 * 文件说明: 用户拦截器
 */
public class Userterceptor implements HandlerInterceptor {
    public static final Logger log = LoggerFactory.getLogger(Userterceptor.class);
    @Autowired
    private TUserService tUserService;

    @Override
    public boolean preHandle(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response, java.lang.Object handler) throws java.lang.Exception
    { log.info("Userterceptor.preHandle");
        log.info("用户拦截器");
        //如果是SpringMVC请求
        if (handler instanceof HandlerMethod) {
            HandlerMethod handlerMethod = (HandlerMethod) handler;
            String methodName = handlerMethod.getMethod().getName();
            log.info("当前拦截的方法为：{}", methodName);
            if("logOn".equals(methodName)){
                return true;
            }
            log.info("当前拦截的方法参数长度为：{}", handlerMethod.getMethod().getParameters().length);
            log.info("当前拦截的类为：{}", handlerMethod.getBean().getClass().getName());
            String uri = request.getRequestURI();
            log.info("拦截的uri:{}" + uri);
        }

        String strUserId = request.getHeader("userId");
        log.info("strUserId:{}",strUserId);
        if(strUserId == null || "".equals(strUserId)){

            return true;
        }
        if(null != strUserId && !"".equals(strUserId)){
            log.info("用户ID为:{}",strUserId);
            Long userId = Long.parseLong(strUserId);
            Result result = tUserService.userFilter(userId);
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
