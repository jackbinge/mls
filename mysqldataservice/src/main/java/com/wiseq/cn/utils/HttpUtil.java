package com.wiseq.cn.utils;

import com.netflix.client.IResponse;
import com.wiseq.cn.commons.exception.QuException;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.apache.poi.util.IOUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;


import javax.servlet.http.HttpServletRequest;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.InetAddress;
import java.net.URL;
import java.net.URLConnection;
import java.net.UnknownHostException;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/1/15 14:08  molei      原始版本
 * 文件说明: 发送http请求算法的工具类
 **/

@Component
public class HttpUtil {
    private static String serverIp;
    private static Integer TRY_TIME;


    @Value("${serverIP}")
    public void setPegsusUserName(String serverIp) {
        HttpUtil.serverIp = serverIp;
    }

    @Value("${try_time}")
    public void setPegsusPwd(Integer TRY_TIME) {
        HttpUtil.TRY_TIME = TRY_TIME;
    }


    public static String HttpRequest(String url) {
        String result = null;
        HttpClient client = HttpClients.createDefault();
        HttpGet httpGet = new HttpGet(serverIp + url);
        HttpResponse response =null;
        try {
            response = client.execute(httpGet);
            Integer count = 0;
            while (response.getStatusLine().getStatusCode() != 200) {
                count++;
                if (count >= TRY_TIME) { //请求次数
                    break;
                }
                response = client.execute(httpGet);
            }
            if (count < TRY_TIME) {
                HttpEntity entity = response.getEntity();
                String returnString = EntityUtils.toString(entity, "UTF-8");
                System.out.println(returnString);
                result = returnString;
            } else {
                throw new QuException(1, "算法服务器连接失败，请重试！");
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
            throw new QuException(1, "服务器响应异常，请重试！" + serverIp + e.getMessage());
        }finally {
            try {
                ((CloseableHttpClient)client).close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return result;
    }


    /**
     * POST 请求
     * @return
     */
    public static String doHttpPost(String xmlInfo, String URL) {
        System.out.println("发起的数据:" + xmlInfo);
        byte[] xmlData = xmlInfo.getBytes();
        InputStream instr = null;
        java.io.ByteArrayOutputStream out = null;
        URL = serverIp + URL;
        try {
            java.net.URL url = new URL(URL);
            URLConnection urlCon = url.openConnection();
            urlCon.setDoOutput(true);
            urlCon.setDoInput(true);
            urlCon.setUseCaches(false);
            urlCon.setRequestProperty("content-Type", "application/json");
            urlCon.setRequestProperty("charset", "utf-8");
            urlCon.setRequestProperty("Content-length",
                    String.valueOf(xmlData.length));
            System.out.println(String.valueOf(xmlData.length));
            DataOutputStream printout = new DataOutputStream(
                    urlCon.getOutputStream());
            printout.write(xmlData);
            printout.flush();
            printout.close();
            instr = urlCon.getInputStream();
            byte[] bis = IOUtils.toByteArray(instr);
            String ResponseString = new String(bis, "UTF-8");
            if ((ResponseString == null) || ("".equals(ResponseString.trim()))) {
                System.out.println("返回空");
            }
            System.out.println("返回数据为:" + ResponseString);
            return ResponseString;

        } catch (Exception e) {
            e.printStackTrace();
            return "0";
        } finally {
            try {
                if(out!=null){
                    out.close();
                }
                if(instr!=null){
                    instr.close();
                }
            } catch (Exception ex) {
                return "0";
            }
        }
    }




    /**
     * 根据http请求获取IP
     *
     * @param request
     * @return
     */
    public static String getIp(HttpServletRequest request) {
        //X-Forwarded-For：Squid 服务代理
        String ip = request.getHeader("x-forwarded-for");
        if (StringUtils.isEmpty(ip) || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
            //Proxy-Client-IP：apache 服务代理
            ip = request.getHeader("Proxy-Client-IP");

        if (StringUtils.isEmpty(ip) || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
            //WL-Proxy-Client-IP：weblogic 服务代理
            ip = request.getHeader("WL-Proxy-Client-IP");

        if (StringUtils.isEmpty(ip) || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
            //HTTP_CLIENT_IP：有些代理服务器
            ip = request.getHeader("HTTP_CLIENT_IP");

        if (StringUtils.isEmpty(ip) || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        if (StringUtils.isEmpty(ip) || ip.length() == 0 || "unknown".equalsIgnoreCase(ip))
            //X-Real-IP：nginx服务代理
            ip = request.getHeader("X-Real-IP");

        // 对于通过多个代理的情况，第一个IP为客户端真实IP,多个IP按照','分割
        String ipSeparate = ",";
        int ipLength = 15;
        if (!StringUtils.isEmpty(ip) && ip.length() > ipLength) {
            if (ip.indexOf(ipSeparate) > 0) {
                ip = ip.substring(0, ip.indexOf(ipSeparate));
            }
        }

        //如果以上均未获取到，则获取本机ip
        if (StringUtils.isEmpty(ip) || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
            String localIp = "127.0.0.1";
            String localIpv6 = "0:0:0:0:0:0:0:1";
            if (ip.equals(localIp) || ip.equals(localIpv6)) {
                // 根据网卡取本机配置的IP
                InetAddress inet;
                try {
                    inet = InetAddress.getLocalHost();
                    ip = inet.getHostAddress();
                } catch (UnknownHostException e) {
                    e.printStackTrace();
                }
            }
        }
        return ip;
    }
}