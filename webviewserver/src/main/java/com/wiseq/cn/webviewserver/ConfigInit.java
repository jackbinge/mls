package com.wiseq.cn.webviewserver;

import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: ConfigInit
 **/
@Configuration
@EnableDiscoveryClient
@EnableFeignClients(basePackages = {"com.wiseq.cn.ykAi.service"})
@ComponentScan(basePackages = {"com.wiseq.cn"})
public class ConfigInit {

}
