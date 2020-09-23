package com.wiseq.cn.commons.utils;

import com.alibaba.excel.ExcelWriter;
import com.alibaba.excel.metadata.Sheet;
import com.alibaba.excel.metadata.Table;
import com.alibaba.excel.metadata.TableStyle;
import com.alibaba.excel.support.ExcelTypeEnum;
import com.wiseq.cn.commons.entity.Merge;
import com.wiseq.cn.commons.entity.Result;
import org.apache.poi.ss.usermodel.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 版本        修改时间        作者        修改内容
 * V1.0        ------        wangyh       原始版本
 * 文件说明: ExcelUtil
 **/
public class ExcelUtil {

    public static final String FORMAT_VALUE_S = "yyyy-MM-dd HH:mm:ss";
    private static final String FORMAT_VALUE_HM = "yyyyMMddHHmm";
    private static int headNum;

    /**
     * 数据导出Excel文件
     * @param columns   表头字段集合
     * @param data      表数据
     * @param fileName  导出文件名
     *
     * 表头参数实例：
     *     单表头: columns {"列1","列2","列3","列4"}
     *     复杂表头：columns {"列1","列2,列21","列2,列22","列3"}  父子列
     */
    public static void export(HttpServletResponse response, List<String> columns, Object data, String fileName){
        // 导出数据解析
        List<List<Object>> dataList = parseData((List<LinkedHashMap<String, Object>>) data);
        try {
            // 处理导出文件名转码处理
            fileName = new String(fileName.getBytes("utf-8"),"ISO-8859-1");
            // 设置浏览器打开方式
            ServletOutputStream outputStream = response.getOutputStream();
            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("content-disposition", "attachment;filename=" + fileName + ".xlsx");
            // 设置表头样式
            TableStyle tableStyle = new TableStyle();
            tableStyle.setTableHeadBackGroundColor(IndexedColors.GREY_50_PERCENT);
            tableStyle.setTableContentBackGroundColor(IndexedColors.WHITE);
            // 设置字体样式
            com.alibaba.excel.metadata.Font font = new com.alibaba.excel.metadata.Font();
            font.setBold(false);
            font.setFontHeightInPoints((short) 11);
            font.setFontName("宋体");
            tableStyle.setTableContentFont(font);
            tableStyle.setTableHeadFont(font);
            // 配置导出类型和表头信息
            Table table = new Table(1);
            table.setHead(parseColumn(columns));
            table.setTableStyle(tableStyle);
            // 创建导出对象
            ExcelWriter writer = new ExcelWriter(null, outputStream,
                    ExcelTypeEnum.XLSX, true, new ExcelStyleHandler(headNum));
            // 配置Sheet
            Sheet sheet = new Sheet(1, 0);
            sheet.setSheetName("sheet1");
            sheet.setAutoWidth(true);
            // 写数据
            writer.write1(dataList, sheet, table);
            writer.finish();
            outputStream.flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 数据导出Excel文件
     * @param columns   表头字段集合
     * @param data      表数据
     * @param fileName  导出文件名
     * @param widthMap  列宽
     *
     * 表头参数实例：
     *     单表头: columns {"列1","列2","列3","列4"}
     *     复杂表头：columns {"列1","列2,列21","列2,列22","列3"}  父子列
     */
    public static void export(HttpServletResponse response, List<String> columns,
                              List<List<Object>> data, String fileName, Map<Integer,Integer> widthMap){
        try {
            // 处理导出文件名转码处理
            fileName = new String(fileName.getBytes("utf-8"),"ISO-8859-1");
            // 设置浏览器打开方式
            ServletOutputStream outputStream = response.getOutputStream();
            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("content-disposition", "attachment;filename=" + fileName + ".xlsx");
            // 设置表头样式
            TableStyle tableStyle = new TableStyle();
            tableStyle.setTableHeadBackGroundColor(IndexedColors.GREY_50_PERCENT);
            tableStyle.setTableContentBackGroundColor(IndexedColors.WHITE);
            // 设置字体样式
            com.alibaba.excel.metadata.Font font = new com.alibaba.excel.metadata.Font();
            font.setBold(false);
            font.setFontHeightInPoints((short) 11);
            font.setFontName("宋体");
            tableStyle.setTableContentFont(font);
            tableStyle.setTableHeadFont(font);
            // 配置导出类型和表头信息
            Table table = new Table(1);
            table.setHead(parseColumn(columns));
            table.setTableStyle(tableStyle);
            // 创建写出对象
            ExcelWriter writer = new ExcelWriter(null, outputStream,
                    ExcelTypeEnum.XLSX, true, new ExcelStyleHandler(headNum));
            // 配置Sheet
            Sheet sheet = new Sheet(1, 0);
            sheet.setSheetName("sheet1");
            // 设置列宽
            if(widthMap != null){
                sheet.setColumnWidthMap(widthMap);
            }else{
                sheet.setAutoWidth(Boolean.TRUE);
            }
            // 写数据
            writer.write1(data, sheet, table);
            writer.finish();
            outputStream.flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 数据导出Excel文件，带合并单元格
     * @param columns   表头字段集合
     * @param data      表数据
     * @param fileName  导出文件名
     * @param margeList 单元格合并参数
     *
     * 表头参数实例：
     *     单表头: columns {"列1","列2","列3","列4"}
     *     复杂表头：columns {"列1","列2,列21","列2,列22","列3"}  父子列
     */
    public static void mergeExport(HttpServletResponse response, List<String> columns,
                              Object data, List<Merge> margeList, String fileName, Map<Integer,Integer> widthMap){
        // 导出数据解析
        List<List<Object>> dataList = parseData((List<LinkedHashMap<String, Object>>) data);
        try {
            // 处理导出文件名转码处理
            fileName = new String(fileName.getBytes("utf-8"),"ISO-8859-1");
            // 设置浏览器打开方式
            ServletOutputStream outputStream = response.getOutputStream();
            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("content-disposition", "attachment;filename=" + fileName + ".xlsx");
            // 设置表头样式
            TableStyle tableStyle = new TableStyle();
            tableStyle.setTableHeadBackGroundColor(IndexedColors.GREY_50_PERCENT);
            tableStyle.setTableContentBackGroundColor(IndexedColors.WHITE);
            // 设置字体样式
            com.alibaba.excel.metadata.Font font = new com.alibaba.excel.metadata.Font();
            font.setBold(false);
            font.setFontHeightInPoints((short) 11);
            font.setFontName("宋体");
            tableStyle.setTableContentFont(font);
            tableStyle.setTableHeadFont(font);
            // 配置导出类型和表头信息
            Table table = new Table(1);
            table.setHead(parseColumn(columns));
            table.setTableStyle(tableStyle);
            // 创建导出对象
            ExcelWriter writer = new ExcelWriter(null, outputStream,
                    ExcelTypeEnum.XLSX, true, new ExcelStyleHandler(headNum));
            // 配置Sheet
            Sheet sheet = new Sheet(1, 0);
            sheet.setSheetName("sheet1");
            // 设置列宽
            if(widthMap != null){
                sheet.setColumnWidthMap(widthMap);
            }else{
                sheet.setAutoWidth(Boolean.TRUE);
            }
            // 写数据
            writer.write1(dataList, sheet, table);
            // 单元格合并处理
            if(margeList != null && margeList.size() > 0){
                margeList.stream().forEach(marge -> writer.merge(
                    marge.getFirstRow(), marge.getLastRow(), marge.getFirstCol(), marge.getLastCol())
                );
            }
            writer.finish();
            outputStream.flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 解析表头
     * @param columns
     * @return
     */
    private static List<List<String>> parseColumn(List<String> columns){
        List<List<String>> columnList = new ArrayList<>();
        columns.stream().forEach(column -> {
            List<String> list = new ArrayList<>();
            if(column.contains(",")){
                String[] cols = column.split(",");
                List<String> newLi = Arrays.asList(cols);
                headNum = headNum < newLi.size()?newLi.size():headNum;
                columnList.add(newLi);
            }else{
                headNum = 1;
                list.add(column);
                columnList.add(list);
            }
        });
        return columnList;
    }

    /**
     * 数据类型转换
     * @param dataList
     * @return
     */
    private static List<List<Object>> parseData(List<LinkedHashMap<String,Object>> dataList){
        List<List<Object>> list = new ArrayList<>();
        if(dataList != null && dataList.size() > 0){
            dataList.stream().forEach(map -> {
                List<Object> dali = Arrays.asList(map.values().toArray());
                list.add(dali);
            });
        }
        return list;
    }

    /**
     * 设置每列宽度
     * @param columns
     * @param data
     * @return
     */
    private static Map<Integer,Integer> parseColumnWidth(List<String> columns, List<Object> data){
        Map<Integer,Integer> widthMap = new HashMap<>();
        for(int i=0; i<columns.size(); i++){
            String columnHead;
            // 如果存在父子级，取最子级
            if(columns.get(i).contains(",")){
                String[] cols = columns.get(i).split(",");
                columnHead = cols[cols.length - 1];
            }else{
                columnHead = columns.get(i);
            }
            // 如果该列数据为空，则直接使用表头字段长度
            if(data != null && data.get(i) != null){
                String dataStr = data.get(i).toString();
                int headWidth = isContainChinese(columnHead)?columnHead.length()*620:columnHead.length()*350+200;
                int contentWidht = isContainChinese(dataStr)?dataStr.length()*620:dataStr.length()*350+200;
                int width = headWidth>contentWidht?headWidth>16000?16000:headWidth:contentWidht>16000?16000:contentWidht;
                widthMap.put(i, width);
                continue;
            }
            int headWidth = isContainChinese(columnHead)?columnHead.length()*620:columnHead.length()*350+200;
            widthMap.put(i, headWidth>16000?16000:headWidth);
        }
        return widthMap;
    }

    /**
     * 判断字符串中是否包含中文
     * @param str   待校验字符串
     * @return  是否为中文
     * @warn 不能校验是否为中文标点符号
     */
    public static boolean isContainChinese(String str) {
        Pattern p = Pattern.compile("[\u4e00-\u9fa5]");
        Matcher m = p.matcher(str);
        if (m.find()) {
            return true;
        }
        return false;
    }

    /**
     * 导出文件名后缀格式
     * @return
     */
    public static String loadFileNameSuffix(){
        SimpleDateFormat sf = new SimpleDateFormat(FORMAT_VALUE_HM);
        return sf.format(new Date()) + (int) (Math.random() * 900 + 100);
    }

    /**
     * 导入Excel
     *
     * @param file    文件
     * @param mapping 导入字段对应map如{("序号", "xh"),("导入时间", "importTime"),{excel字段名,代码字段名}}
     * @return
     * @throws Exception
     */
    public static Result importExcel(MultipartFile file, Map<String, String> mapping){
        // 根据文件名来创建Excel工作薄
        // 返回数据
        String fileName = file.getOriginalFilename();
        List<LinkedHashMap<String, Object>> ls = new ArrayList<>();
        try{
            InputStream inputStream = file.getInputStream();
            Workbook workbook = WorkbookFactory.create(inputStream);
            if (null == workbook) {
                throw new Exception("Excel工作薄为空！");
            }
            org.apache.poi.ss.usermodel.Sheet sheet;
            Row row; Cell cell;

            // 遍历Excel中所有的sheet
            //for (int i = 0; i < workbook.getNumberOfSheets(); i++) {
                sheet = workbook.getSheetAt(0);
                if (sheet == null) return ResultUtils.error(-1, "文件数据为空，请重试！");
                // 取第一行标题
                row = sheet.getRow(0);
                Map<Integer,Object> title=new HashMap<Integer,Object>();
                List<String> cols=new ArrayList<String>();
                // 行为空
                if (row == null)  return ResultUtils.error(-1, "文件数据为空，请重试！");
                for (int y = row.getFirstCellNum(); y < row.getLastCellNum(); y++) {
                    cell = row.getCell(y);
                    Object col=getCellValue(cell);
                    if(col!=null){
                        cols.add(col.toString().trim());
                        if(mapping.get(col.toString().trim())!=null){
                            title.put(y, col.toString().trim());
                        }
                    }

                }
               //判断excel文件中是否有列名重复的列
                Set<String> set=new HashSet<String>(cols);
                if(cols.size()!=set.size()){
                    return ResultUtils.error(-1, "文件列名重复，请检查后重试！");
                }
               //当excel列与导入列不相等返回空
                if(mapping.size()!=title.size()){
                    return ResultUtils.error(-1, "文件列名不符合要求，请检查后重试！");
                }
                // 遍历当前sheet中的所有行
                for (int j = 1; j < sheet.getLastRowNum() + 1; j++) {
                    row = sheet.getRow(j);
                    if (row == null)break;
                    if (isNullOrEmpty(row)) break;
                    LinkedHashMap<String, Object> m = new LinkedHashMap<String, Object>();
                    // 遍历所有的列
                    for (int y = row.getFirstCellNum(); y < row.getLastCellNum(); y++) {
                       if(title.get(y)!=null){
                           cell = row.getCell(y);
                           m.put(mapping.get(title.get(y)), getCellValue(cell));
                       }
                    }
                    ls.add(m);
                }
            //}
            workbook.close();
        }catch (Exception e){
            e.printStackTrace();
        }
        return ResultUtils.success(ls);
    }

    /**
     * 判断是否为空
     * @param row
     * @return
     */
    public static Boolean isNullOrEmpty(Row row){
        for (int y = row.getFirstCellNum(); y < row.getLastCellNum(); y++) {
            Cell  cell = row.getCell(y);
            if(getCellValue(cell)!=null&&!"".equals(getCellValue(cell))){
                return false;
            };
        }
        return true;
    }

    /**
     * 描述：对表格中数值进行格式化
     *
     * @param cell
     * @return
     */
    public static Object getCellValue(Cell cell) {
        Object value = null;
        DecimalFormat df = new DecimalFormat("0.00"); // 格式化number String字符
        SimpleDateFormat sdf = new SimpleDateFormat(FORMAT_VALUE_S); // 日期格式化
        DecimalFormat df2 = new DecimalFormat("0"); // 格式化数字
       if(cell!=null){
           switch (cell.getCellTypeEnum()) {
               case STRING:
                   value = cell.getRichStringCellValue().getString();
                   break;
               case NUMERIC:
                   if ("General".equals(cell.getCellStyle().getDataFormatString())) {
                       value = cell.getNumericCellValue();
                   } else if ("m/d/yy".equals(cell.getCellStyle().getDataFormatString())) {
                       value = sdf.format(cell.getDateCellValue());
                   } else {
                       //value = df2.format(cell.getNumericCellValue());
                       value = cell.getNumericCellValue();
                   }
                   break;
               case BOOLEAN:
                   value = cell.getBooleanCellValue();
                   break;
               case BLANK:
                   value = "";
                   break;
               default:
                   break;
           }
       }
        return value;
    }
}
