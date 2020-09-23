package com.wiseq.cn.commons.utils;

import com.alibaba.fastjson.JSONObject;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.Map;

/**
 * 版本        修改时间        作者        修改内容
 * V1.0        ------        wangyanhui   原始版本
 * 文件说明: SparkUtil  Spark操作类
 **/
public class SparkUtil {

    /**
     * Spark 调用提交任务
     * @param url     请求路径
     * @param param   业务参数集合
     */
    public static Map<String,Object> submitJobToSpark(String url, String param) {
        return sendUrl(url, param);
    }

    /**
     *  Spark 查询任务结果
     * @param url    请求地址
     * @param param  submissionId 任务ID
     */
    public static Map<String,Object> loadJobFromSpark(String url, String param){
        return loadUrl(url + param);
    }

    /**
     *  发送任务请求
     * @param url   请求地址
     * @param param 请求参数
     * @return Map<String,String>
     * action 请求的内容是提交程序
     * message 返回信息
     * serverSparkVersion 服务器Spark版本
     * submissionId 任务ID,用于监控任务
     * success 是否成功
     */
    private static Map<String,Object> sendUrl(String url, String param){
        System.err.println("url:" + url);
        StringBuffer resultBuffer = new StringBuffer();
        try {
            URL localURL = new URL(url);
            URLConnection connection = localURL.openConnection();
            HttpURLConnection httpURLConnection = (HttpURLConnection)connection;

            httpURLConnection.setDoOutput(true);
            httpURLConnection.setRequestMethod("POST");
            httpURLConnection.setRequestProperty("Accept-Charset", "utf-8");
            httpURLConnection.setRequestProperty("Content-Type", "application/json");
            httpURLConnection.setRequestProperty("Content-Length", String.valueOf(param.length()));

            OutputStream outputStream = null;
            OutputStreamWriter outputStreamWriter = null;
            InputStream inputStream = null;
            InputStreamReader inputStreamReader = null;
            BufferedReader reader = null;


            try {
                outputStream = httpURLConnection.getOutputStream();
                outputStreamWriter = new OutputStreamWriter(outputStream);

                outputStreamWriter.write(param);
                outputStreamWriter.flush();

                if (httpURLConnection.getResponseCode() >= 300) {
                    throw new Exception("请求失败, 结果代码：" + httpURLConnection.getResponseCode());
                }

                inputStream = httpURLConnection.getInputStream();
                inputStreamReader = new InputStreamReader(inputStream);
                reader = new BufferedReader(inputStreamReader);

                String tempLine = null;
                while ((tempLine = reader.readLine()) != null) {
                    resultBuffer.append(tempLine);
                }
            } finally {
                if (outputStreamWriter != null) outputStreamWriter.close();
                if (outputStream != null) outputStream.close();
                if (reader != null) reader.close();
                if (inputStreamReader != null) inputStreamReader.close();
                if (inputStream != null) inputStream.close();
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return parseResult(resultBuffer.toString());
    }

    /**
     *  获取任务信息
     * @param url 请求地址
     * @return Map<String,String>
     * workerId 任务节点id
     * serverSparkVersion 服务器Spark版本
     * submissionId 任务ID
     * driverState 任务状态(ERROR(因错误没有提交成功，会显示错误信息), SUBMITTED(已提交但未开始执行),
     *                      RUNNIG(正在运行), FAILED(执行失败，会抛出异常), FINISHED(执行成功))
     * success 是否成功
     * action 请求的内容是提交程序
     * workerHostPort 任务节点地址及端口
     */
    private static Map<String,Object> loadUrl(String url){
        System.err.println("url:" + url);
        InputStream in = null;
        StringBuffer resultBuffer = new StringBuffer();
        try {
            //连接
            URL localURL = new URL(url);
            URLConnection uc = localURL.openConnection();

            //获取读入流
            in = uc.getInputStream();
            //放入缓存流
            InputStream raw = new BufferedInputStream(in);
            //最后使用Reader接收
            Reader r = new InputStreamReader(raw);
            // 结果输出
            int c;
            while((c = r.read()) > 0){
                resultBuffer.append((char)c);
            }
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally{
            try {
                if(in!=null) in.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return parseResult(resultBuffer.toString());
    }

    /**
     *  请求结果解析
     * @param result 结果数据
     * @return
     */
    private static Map<String,Object> parseResult(String result){
        Map<String,Object> mapObj = JSONObject.parseObject(result, Map.class);
        return mapObj;
    }
}
