package com.wiseq.cn.config;

import com.wiseq.cn.commons.exception.QuException;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 版本        修改时间        作者        修改内容
 * V1.0        ------        songlp       原始版本
 * 文件说明: 用户身份认证
 **/
public class AuthenticationIntercepter implements HandlerInterceptor {
    //可以随意访问的url
    public String[] allowUrls;

    public void setAllowUrls(String[] allowUrls) {
        this.allowUrls = allowUrls;
    }
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object o) throws Exception {
        String requestUrl = request.getRequestURI().replace(request.getContextPath(), "");
        response.setContentType("text/html;charset=utf-8");
        //如果是c端登录，不进行验证
//        if("c".equals(request.getHeader("clientFlag"))){
//            return true;
//        }
//        //过滤允许直接访问的请求
//        if(requestUrl!=null){
//            for(String url:allowUrls){
//                if(requestUrl.contains(url)){
//                    return true;
//                }
//            }
//        }
        //防止从浏览器地址直接输入访问
//        if (request.getHeader("Referer") == null) {
//            throw new QuException(-1,"无访问权限，请先登陆！");
//        }
        //从cookie获取token信息
        /*
        String token=CookiesUtils.readCookies("token");
         if(QuHelper.isNull(token)){
            throw new QuException(-1,"token信息为空，请重新登陆！");
        }
        TokenUtil.volidate(token);
        */
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

    }

}
