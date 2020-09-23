package com.wiseq.cn.zuulegate;

import com.wiseq.cn.zuulegate.license.LicenseFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.cloud.netflix.zuul.EnableZuulProxy;
import org.springframework.context.annotation.Bean;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        jpdong     原始版本
 * 文件说明: zuule
 **/

@SpringBootApplication
@ServletComponentScan
@EnableZuulProxy
public class ZuulegateApplication {
	@Autowired
	private DiscoveryClient discoveryClient;

	/**
	 * 获取所有服务
	 */
	@RequestMapping("/services")
	public Object services() {
		return discoveryClient.getServices();
	}

	@RequestMapping("/home")
	public String home() {
		return "Hello World";
	}
	public static void main(String[] args) {
		SpringApplication.run(ZuulegateApplication.class, args);
		System.out.println("------- ZuulegateApp has started -------");
	}
	@Bean
	public LicenseFilter licenseFilter(){
		return new LicenseFilter();
	}
}
