package com.wiseq.cn.utils;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.webview.Recursion;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0        ------        silver     原始版本
 * 文件说明: FindChild
 **/

public class FindChild {

    /**
     * 递归处理部门或者工厂
     * liuchao
     *
     * @param all
     * @param t
     * @param recursion
     * @param <T>
     * @throws NoSuchFieldException
     * @throws IllegalAccessException
     */
    public static <T> void findChild(List<T> all, T t, Recursion recursion) throws NoSuchFieldException, IllegalAccessException {
        Field tRolesField = ((T) t).getClass().getDeclaredField("roles");
        tRolesField.setAccessible(true);
        List<Recursion> tempRoles = (List<Recursion>) tRolesField.get(t);
        //处理 角色 - 人员
        List<Recursion> list = recursion.getChildren();
        if (null == list) list = new ArrayList<>();
        if (null != tempRoles) list.addAll(tempRoles);
        recursion.setChildren(list);

        for (T temp : all) {
            Field tCodeField = ((T) t).getClass().getDeclaredField("code");
            Field tempCodeField = ((T) temp).getClass().getDeclaredField("code");
            Field tempParentCodeField = ((T) temp).getClass().getDeclaredField("parentCode");
            Field tempNameField = ((T) temp).getClass().getDeclaredField("name");
            Field tempIdField = ((T) temp).getClass().getDeclaredField("id");

            tCodeField.setAccessible(true);
            tempCodeField.setAccessible(true);
            tempParentCodeField.setAccessible(true);
            tempNameField.setAccessible(true);
            tempIdField.setAccessible(true);

            String tCode = tCodeField.get((t)).toString();
            String tempCode = tempCodeField.get(temp).toString();
            String tempParentCode = tempParentCodeField.get(temp).toString();
            String tempName = tempNameField.get(temp).toString();
            Integer tempId = Integer.valueOf(tempIdField.get(temp).toString());

            if (tCode.equals(tempParentCode)) {
                Recursion recursion1 = new Recursion();
                recursion1.setMainId(tempId);
                recursion1.setId(tempCode);
                recursion1.setLabel(tempName);
                recursion1.setGrade(1);
                list.add(recursion1);
                findChild(all, temp, recursion1);
            }
        }
    }


    /**
     * 处理结果数据
     *
     * @param t
     * @param <T>
     * @return
     */
    public static <T> Result dealResult(T t) {
        Result<T> result = new Result<>();
        result.setCode(0);
        result.setMessage("");
        result.setData(t);
        return result;
    }
}
