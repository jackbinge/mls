package com.wiseq.cn.commons.utils;

import java.util.UUID;

public class ID {

	private ID(){}

	/**
	 * 获取生成的ID
	 * @return
	 */
	public static String get(){
		String id = UUID.randomUUID().toString();
		return id.replaceAll("-", "");
	}


}
