package com.wiseq.cn.utils;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.utils.QuHelper;
import com.wiseq.cn.entity.webview.SysRole;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        liuchao     原始版本
 * 文件说明: PageUtil
 **/
public class PageUtil {
    /**
     * @param dataArray 查询出来的所有数据
     * @param pageNum   当前页
     * @param pageSize  每页的数量
     * @return pageInfo:total 总记录数
     * pages 总页数
     * list 结果集
     */
    public static <T> PageInfo getPageList(List<T> dataArray, Integer pageNum, Integer pageSize) {
        PageInfo<T> pageInfo = new PageInfo<>(dataArray);
        return pageInfo;
    }

    /**
     * pageHelper 处理
     *
     * @param pageNum
     * @param pageSize
     */
    public static void pageHelper(Integer pageNum, Integer pageSize) {
        if (!QuHelper.isNumeric(pageNum) || pageNum < 1)
            pageNum = 1;

        if (!QuHelper.isNumeric(pageSize) || pageSize < 1)
            pageSize = 1;

        PageHelper.startPage(pageNum, pageSize);
    }

    /**
     * list分页处理
     *
     * @param list     需要分页的对象
     * @param pageNum  页码
     * @param pageSize 页数据量
     * @param filed    排序字段
     * @param sort     排序标识
     * @param <T>
     * @return
     */
    public static <T> Map<String, Object> pageList(List<T> list, long pageNum, long pageSize, String filed, String sort) {
        Map<String, Object> result = new HashMap<>();
        if (pageNum == 0 || pageNum == 1) pageNum = 1;
        //排序
        sortList(list, filed, sort);
        //每页开始的分割的下标
        long start = (pageNum - 1) * pageSize;
        List<T> resultData = list.stream().skip(start).limit(pageSize).collect(Collectors.toList());


        //获取总数
        int total = list.size();

        int param = (int) (total % pageSize);
        //总页数
        int pages;
        if (param > 0) pages = (int) ((total / pageSize) + 1);
        else pages = (int) (total / pageSize);

        //封装结果
        result.put("list", resultData);
        result.put("total", total);
        result.put("page", pages);

        return result;
    }

    /**
     * 排序
     *
     * @param list
     * @param filed
     * @param sort
     * @param <E>
     */
    public static <E> void sortList(List<E> list, String filed, String sort) {
        Collections.sort(list, new Comparator() {
            public int compare(Object a, Object b) {
                int ret = 0;
                String firstParm = null;
                String secondParm = null;
                try {
                    if (null != filed) {
                        Field m1 = ((E) a).getClass().getDeclaredField(filed);
                        Field m2 = ((E) b).getClass().getDeclaredField(filed);
                        m1.setAccessible(true);
                        m2.setAccessible(true);
                        firstParm = m1.get(((E) a)).toString();
                        secondParm = m2.get(((E) b)).toString();

                    } else {
                        firstParm = String.valueOf(a);
                        secondParm = String.valueOf(b);
                    }

                    if (null == firstParm) firstParm = "";
                    if (null == secondParm) secondParm = "";

                    if (sort != null && "desc".equals(sort.toLowerCase()))
                        //倒序
                        ret = secondParm.compareTo(firstParm);
                    else
                        //正序
                        ret = firstParm.compareTo(secondParm);
                } catch (NoSuchFieldException e) {
                    e.printStackTrace();
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                }
                return ret;
            }
        });
    }
}
