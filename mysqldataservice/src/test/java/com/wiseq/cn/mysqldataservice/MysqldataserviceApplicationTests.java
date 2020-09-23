package com.wiseq.cn.mysqldataservice;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.Properties;

@RunWith(SpringRunner.class)
@SpringBootTest
public class MysqldataserviceApplicationTests {

	@Test
	public void contextLoads() throws Exception {
		String url = "jdbc:mysql://192.168.2.51:8075/quanshisoft?characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull&autoReconnect=true";

		Properties properties = new Properties();
		properties.setProperty("user", "root");
		properties.setProperty("password", "traits1023");
		properties.setProperty("remarks", "true"); //设置可以获取remarks信息
		properties.setProperty("useInformationSchema", "true");//设置可以获取tables remarks信息

		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection(url, properties);
		DatabaseMetaData metaData = conn.getMetaData();
		ResultSet tableRet = metaData.getTables(null, "%", null, new String[]{"TABLE"});
		while(tableRet.next()){
			String tableName = tableRet.getString("TABLE_NAME");
			String tableComment = tableRet.getString("REMARKS");
			ResultSet colRet = metaData.getColumns(null,"%", tableName,"%");
			while(colRet.next()) {
				String columnName = colRet.getString("COLUMN_NAME");
				String columnType = colRet.getString("TYPE_NAME").toLowerCase();
				int datasize = colRet.getInt("COLUMN_SIZE");
				String remarks = colRet.getString("REMARKS");
				System.err.println(tableName + "(" + tableComment + "):" + columnName + "  " + columnType + "("+ datasize + ")  ["+ remarks + "]");
			}
		}
	}
}
