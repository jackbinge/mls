package com.wiseq.cn.commons.utils;

import com.alibaba.excel.event.WriteHandler;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.ss.usermodel.*;

/**
 * 版本        修改时间        作者        修改内容
 * V1.0        ------        wangyh       原始版本
 * 文件说明: ExcelStyleHandler
 **/
public class ExcelStyleHandler implements WriteHandler {

    private int headNum;

    public ExcelStyleHandler(int headNum){
        this.headNum = headNum;
    }

    @Override
    public void sheet(int i, Sheet sheet) {
        // 冻结行
        for(int h=1; h<=headNum; h++){
            sheet.createFreezePane(0, h, 0, h);
        }
    }

    @Override
    public void row(int i, Row row) {
        // 设置行高
        if(i < headNum){
            // 表头行高
            row.setHeight((short) 500);
        }
    }

    @Override
    public void cell(int i, Cell cell) { }
}
