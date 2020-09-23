package com.wiseq.cn.utils;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class CSVUtils {
    /**
     * 导出
     *
     * @param pathName csv文件(路径+文件名)，csv文件不存在会自动创建
     * @param dataList 数据
     * @return
     */
    public static boolean exportCsv(String pathName, List<String> dataList){
        boolean isSucess=false;

        FileOutputStream out=null;
        OutputStreamWriter osw=null;
        BufferedWriter bw=null;
        File file=new File(pathName);

        //判断文件是否已经存在
        if (file.exists()) {
            //如果已存在则删除
            file.delete();
        }

        //判断文件父目录是否存在
        if (!file.getParentFile().exists()) {
            file.getParentFile().mkdir();
        }

        try {
            out = new FileOutputStream(file);
            osw = new OutputStreamWriter(out);
            bw =new BufferedWriter(osw);
            if(dataList!=null && !dataList.isEmpty()){
                for(String data : dataList){
                    bw.append(data).append("\r");
                }
            }
            isSucess=true;
        } catch (Exception e) {
            isSucess=false;
        }finally{
            if(bw!=null){
                try {
                    bw.close();
                    bw=null;
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if(osw!=null){
                try {
                    osw.close();
                    osw=null;
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if(out!=null){
                try {
                    out.close();
                    out=null;
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return isSucess;
    }


    /**
     * 导入
     *
     * @param file csv文件(路径+文件)
     * @return list<String>每个元素，代表一行数据
     */
    public static List<String> importCsv(File file){
        List<String> dataList=new ArrayList<String>();

        BufferedReader br=null;
        try {
            br = new BufferedReader(new FileReader(file));
            String line = "";
            while ((line = br.readLine()) != null) {
                dataList.add(line);
            }
        }catch (Exception e) {
        }finally{
            if(br!=null){
                try {
                    br.close();
                    br=null;
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return dataList;
    }

    /**
     * 导入
     *
     * @param file csv文件(路径+文件)
     * @param separator 例如 ","这样的分隔符
     * @return list<String>每个元素，代表一行数据
     */
    public static List<String[]> importCsv(File file,String separator){
        List<String[]> dataList=new ArrayList<String[]>();

        BufferedReader br=null;
        try {
            br = new BufferedReader(new FileReader(file));
            String line = "";
            while ((line = br.readLine()) != null) {
                String[] lines=line.split(separator);
                dataList.add(lines);
            }
        }catch (Exception e) {
        }finally{
            if(br!=null){
                try {
                    br.close();
                    br=null;
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return dataList;
    }



    public static void main(String[] args){
        /************************导出***********************/
         List<String> dataList=new ArrayList<>();
         dataList.add("1,张三,男");
         dataList.add("2,李四,男");
         dataList.add("3,小红,女");
         boolean isSuccess=CSVUtils.exportCsv("D:/test/ljq.csv", dataList);
         System.out.println(isSuccess);
         /************************导出**********************/

         /************************导入1***********************/
         List<String> dataList1=CSVUtils.importCsv(new File("D:/test/ljq.csv"));
         if(dataList1!=null && !dataList1.isEmpty()){
             for(String data : dataList1){
                 System.out.println(data);
             }
         }
         /************************导入1***********************/


         /************************导入2***********************/
         List<String[]> dataList2=CSVUtils.importCsv(new File("D:/test/ljq.csv"),",");
         if(dataList2!=null && !dataList2.isEmpty()){
             for(String[] data : dataList2){
                 for(String temp:data){
                    System.out.print(temp);
                    System.out.print("  ");
                 }
                 System.out.println();
             }
         }
         /************************导入2***********************/
     }

}
