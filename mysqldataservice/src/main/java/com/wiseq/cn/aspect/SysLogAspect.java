package com.wiseq.cn.aspect;

import com.alibaba.fastjson.JSON;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.CookiesUtils;
import com.wiseq.cn.entity.webview.SysLog;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.*;
import org.aspectj.lang.reflect.CodeSignature;
import org.aspectj.lang.reflect.MethodSignature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.Method;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * 版本        修改时间        作者        修改内容
 * V1.0        ------        songlp       原始版本
 * 文件说明: SysLogAspect
 **/
@Aspect
@Component
public class SysLogAspect {
    private final static Logger logger = LoggerFactory.getLogger(SysLogAspect.class);
    private  String[] allowUrls;
    @Autowired
    private  HttpServletRequest request;
    //这个切点的表达式需要根据自己的项目来写
    @Pointcut("execution(public * com.wiseq.cn.controller..*(..)) || execution(public * com.wiseq.cn.epitop.controller..*(..))")
    public void logPoinCut() {

    }
    @Before("logPoinCut()")
    public void doBefore(JoinPoint joinPoint) {
       // logger.info("系统未登录或登录超时，请重新登录");
//        allowUrls=new String[]{"login","import"};
//        boolean allow=true;
//        String requestUrl = request.getRequestURI().replace(request.getContextPath(), "");
//        //判断哪些方法不进行过滤
//        if(requestUrl!=null){
//            for(String url:allowUrls){
//                if(requestUrl.contains(url)){
//                    allow= false;
//                }
//            }
//        }
//        if(allow){
//            String userId=request.getHeader("userId");
//            if (!QuHelper.isNumeric(userId)){
//                throw new QuException(-100,"系统未登录或登录超时，请重新登录");
//            }
//        }
    }
    @After("logPoinCut()")
    public void doAfter(JoinPoint joinPoint) {
        //logger.info("aop doAfter");
    }

    @AfterThrowing(value="logPoinCut()",throwing = "e")
    public void afterThowing(JoinPoint joinPoint,Exception e){
        logger.error("exception",e);
        //logger.info("exception",e);
    }

    @AfterReturning(returning = "result",value = "logPoinCut()")
    public  void doAfterReturning(JoinPoint joinPoint, Result result){
        String userId= CookiesUtils.readCookies("userId");
        //从切面织入点处通过反射机制获取织入点处的方法
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        //获取切入点所在的方法
        Method method = signature.getMethod();
        String name = method.getName();
        // 获取请求的类名
        String classname = joinPoint.getTarget().getClass().getName();
        // 获取请求的方法名
        String methodname = classname+"."+method.getName();
        // 获取请求方式
        String Method = request.getMethod();
        // 获取请求url
        String url = request.getRequestURI().toString();
        // 获取请求的ip地址
        String ip =this.getIpAddr(request);
        // 获取请求的参数
        String argsname[] = ((CodeSignature) joinPoint.getSignature()).getParameterNames();
        //过滤不进行日志记录的方法
        if ("upload".equals(name) ||name.contains("import")||name.contains("findNoReadNum")||name.contains("saveBinNorm")||name.contains("print")||name.contains("autoCheck"))
            return;
        Map<String,Object> parammap = new HashMap<>();
        if(argsname.length>0){
            parammap= getParam(joinPoint,argsname);
        }
        String params = JSON.toJSONString(parammap);
        //操作返回结果
        Integer code=result.getCode();
        SysLog sysLog=new SysLog();
        sysLog.setUrl(url);
        sysLog.setIp(ip);
        if(userId!=null&&!"".equals(userId) &&!"null".equals(userId)){
            sysLog.setUserId(Integer.parseInt(userId));
        }
//        else{
//            userId=request.getHeader("userId");
//            if(userId!=null&&!userId.equals("")&&!userId.equals("null")){
//                sysLog.setUserId(Integer.parseInt(userId));
//            }
//        }
        if(code==0){
            sysLog.setResult("成功");
        }else{
            sysLog.setResult("失败");
        }
        sysLog.setParams(params);
        sysLog.setOperateTime(new Date());
         //sysLogService.insert(sysLog);
        logger.info(sysLog.toString());
    }


    /**
     * 从request中获取请求方IP
     *
     * @param request
     * @return
     */

    public  String getIpAddr(HttpServletRequest request) {

        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
     return ip;
    }

    // 处理参数格式,并返回需要的参数
    public static Map<String, Object> getParam(JoinPoint joinPoint, String argsname[]) {
        Map<String, Object> map = new HashMap<>();
        // 获取参数值
        Object args[] = joinPoint.getArgs();
        // 获取参数名
        argsname = ((CodeSignature) joinPoint.getSignature()).getParameterNames();
        for (int i = 0; i < argsname.length; i++) {
            map.put(argsname[i], args[i]);
        }
        return map;
    }
}
