package com.wiseq.cn.mysqldataservice;

import org.springframework.boot.autoconfigure.EnableAutoConfiguration;

import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: 初始化配置
 **/
@Configuration
@EnableDiscoveryClient
@EnableAutoConfiguration
@ComponentScan(basePackages = {"com.wiseq.cn"})
public class ConfigInit {

}
