package com.wiseq.cn.entity.ykAi;

import lombok.Data;

import java.util.List;


/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       jiangbailing     原始版本
 * 文件说明:  BOM修改列表
 */

@Data
public class TBOMUpdatePage {
    /**
     * 要删除的BOM
     */
    List<TBom> deleteList;

    /**
     * 要新增的BOM
     */
    List<TBom> addList;

    /**
     * 修改的list
     */
    List<TBom> updateList;

}
