package com.wiseq.cn.config;

import com.wiseq.cn.filter.Taskterceptor;
import com.wiseq.cn.filter.Userterceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

/**
 * 版本        修改时间        编者      备注
 * V1.0        ------        jpdong    原始版本
 * 文件说明:
 **/
@Configuration
public class WebMvcConfig  extends WebMvcConfigurerAdapter {
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/static/**").addResourceLocations("classpath:/static/");

        registry.addResourceHandler("swagger-ui.html")
                .addResourceLocations("classpath:/META-INF/resources/");

        registry.addResourceHandler("/webjars/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/");



    }
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        AuthenticationIntercepter authentication = new AuthenticationIntercepter();
        String allowUrls[] = {"login","swagger"};
        authentication.setAllowUrls(allowUrls);
        //添加拦截器
        registry.addInterceptor(authentication);
        //添加工单拦截器
        registry.addInterceptor(Taskterceptor()).addPathPatterns("/**");

        //添加工单拦截器
        registry.addInterceptor(Userterceptor()).addPathPatterns("/**");

        super.addInterceptors(registry);
    }



    @Bean
    public Taskterceptor Taskterceptor() {
        return new Taskterceptor();
    }

    @Bean
    public Userterceptor Userterceptor(){
        return new Userterceptor();
    }
}
