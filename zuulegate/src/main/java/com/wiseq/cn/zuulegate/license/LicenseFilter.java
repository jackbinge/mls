package com.wiseq.cn.zuulegate.license;

import com.alibaba.fastjson.JSON;
import com.netflix.zuul.ZuulFilter;
import com.netflix.zuul.context.RequestContext;
import com.netflix.zuul.exception.ZuulException;
import com.wiseq.cn.commons.utils.ResultUtils;
import de.schlichtherle.license.LicenseContent;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;

import javax.servlet.http.HttpServletRequest;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class LicenseFilter extends ZuulFilter {
    public static final Logger log = LoggerFactory.getLogger(LicenseFilter.class);

    @Value("${license.subject}")
    private String subject;

    /**
     * 公钥别称
     */
    @Value("${license.publicAlias}")
    private String publicAlias;

    /**
     * 访问公钥库的密码
     */
    @Value("${license.storePass}")
    private String storePass;

    /**
     * 证书生成路径
     */
    @Value("${license.licensePath}")
    private String licensePath;

    /**
     * 密钥库存储路径
     */
    @Value("${license.publicKeysStorePath}")
    private String publicKeysStorePath;

    @Override
    public String filterType() {
        return "pre";
    }

    @Override
    public int filterOrder() {
        return 0;
    }

    @Override
    public boolean shouldFilter() {
        return true;
    }

    @Override
    public Object run() throws ZuulException {

        RequestContext ctx = RequestContext.getCurrentContext();
        HttpServletRequest request = ctx.getRequest();
        String method = request.getMethod();
        String url = request.getRequestURI();
        log.info("方法为{}",method);
        log.info("请求路径为{}",url);
        //校验证书是否有效
        if ("/actuator/health".equalsIgnoreCase(request.getRequestURI())){
            return true;
        }
        if ("/webviewserver/license/info".equalsIgnoreCase(request.getRequestURI())) {
            LicenseVerify licenseVerify = new LicenseVerify();
            LicenseVerifyParam param = new LicenseVerifyParam();
            param.setSubject(subject);
            param.setPublicAlias(publicAlias);
            param.setStorePass(storePass);
            param.setLicensePath(licensePath);
            param.setPublicKeysStorePath(publicKeysStorePath);
            licenseVerify.install(param);
            LicenseContent licenseContent = licenseVerify.install(param);
            if (licenseContent!=null){
                verify_success(ctx, licenseContent);
                return true;
            }else {
                Verify_failed(ctx);
                return true;
            }
        } else {
            LicenseVerify licenseVerify = new LicenseVerify();
            if (!licenseVerify.verify()) {
                Verify_failed(ctx);
                return true;
            }
            return true;
        }
    }

    private void verify_success(RequestContext ctx, LicenseContent licenseContent) {
        DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Map<String, Integer> result = new HashMap<>(1);
        result.put("days", (int) ((licenseContent.getNotAfter().getTime() - new Date().getTime()) / (1000 * 3600 * 24)));
        ctx.setSendZuulResponse(true);
        ctx.addZuulResponseHeader("Content-Type", "application/json;charset=UTF-8");
        ctx.setResponseStatusCode(200);
        ctx.setResponseBody(JSON.toJSONString(ResultUtils.success(result)));
    }

    private void Verify_failed(RequestContext ctx) {
        DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Map<String, Object> result = new HashMap<>(1);
        result.put("code", 999);
        result.put("message", "授权过期或者无效！");
        ctx.setSendZuulResponse(true);
        ctx.setResponseStatusCode(200);
        ctx.addZuulResponseHeader("Content-Type", "application/json;charset=UTF-8");
        ctx.setResponseBody(JSON.toJSONString(result));
    }
}
