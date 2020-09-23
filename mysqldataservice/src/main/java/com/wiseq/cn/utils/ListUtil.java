 package com.wiseq.cn.utils;

import com.wiseq.cn.entity.ykAi.XYDTO;
import org.apache.poi.ss.formula.functions.T;

import java.util.*;
import java.util.logging.Logger;
import java.util.stream.Collectors;

 /**
 * 版本        修改时间        作者        修改内容
 * V1.0        ------        songlp       原始版本
 * 文件说明: ListUtil
 **/
public class ListUtil {
    //去除list中重复元素
    public static List removeRepeatMeta(List list) {
        HashSet h = new HashSet(list);
        list.clear();
        list.addAll(h);
        return list;
    }

    /**
     * 判断两个List是否相同
     * 要重写equals 方法 和 comples
     *
     * @param list0
     * @param list1
     * @return
     */
    public static boolean isListEqual(List list0, List list1) {
        if (null == list0 && null == list1)
            return true;

        if (null != list0 && null == list1)
            return false;

        if (null == list0 && null != list1)
            return false;
        if (list0.size() != list1.size()){
            return false;
        }

        //排序
        Collections.sort(list0);
        list1.sort(Comparator.naturalOrder());
        System.out.println(list0);
        System.out.println(list1);
        for (int i = 0;i < list0.size();i++) {
            if(!list1.get(i).equals(list0.get(i))){
                return false;
            }
        }
        return true;

    }

    public static void main(String[] args) {
        // 这两种情况就有问题 因为单个list包含的元素种类
        ArrayList<String> list0 = new ArrayList(Arrays.asList("1","2","1"));
        ArrayList<String> list1 = new ArrayList(Arrays.asList("2","2","1"));

        System.out.println("list0:---------->"+list0);
        System.out.println("list1:---------->"+list1);

        Collections.sort(list0);
        list1.sort(Comparator.naturalOrder());
        System.out.println("list0:---------->"+list0);
        System.out.println("list1:---------->"+list1);
        //所以用包含就有问题
        System.out.println(list0.containsAll(list1));
        System.out.println(list1.containsAll(list0));
        System.out.println(isListEqual(list0,list1));
        String str = "1";


        System.out.println("1".equals("2"));

        List xydtoList0 = new ArrayList<XYDTO>(
                Arrays.asList(
                        new XYDTO(0.1,0.2),
                        new XYDTO(0.1,0.1),
                        new XYDTO(0.1,0.1),
                        new XYDTO(0.1,0.1)));
        List xydtoList1 = new ArrayList<XYDTO>(
                Arrays.asList(
                        new XYDTO(0.1,0.1),
                        new XYDTO(0.1,0.1),
                        new XYDTO(0.1,0.1),
                        new XYDTO(0.1,0.2)));
        //System.out.println(isListEqual(xydtoList0,xydtoList1));
        double x = Double.parseDouble("+1.0");
        System.out.println(x);

        System.out.println(xydtoList0.stream().sorted().collect(Collectors.toList()));
        Logger.global.finest("x=" + x);
    }
}
