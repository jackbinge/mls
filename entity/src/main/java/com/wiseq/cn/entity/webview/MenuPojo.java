package com.wiseq.cn.entity.webview;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
public class MenuPojo {
    private Integer id;//
    private String name;//菜单名称
    private String label;
    private Integer parentId;//父对象
    private Integer isShow;//是否开放，0：不开放，1：开放
    private String router;//路由名称，前端使用
    private String routerPath;//路由路径，前端使用
    private String icon;//菜单图标
    private Integer viewOrder;//排序
    private boolean isSelect;//权限选择回填数据，判断之前是否选中
    private boolean disabled;  //前端选择时用，true:不可以选择，false:可以选择
    private String funIds;
    private List<MenuPojo> children = new ArrayList<MenuPojo>();
    private List<SysFunction> Functions = new ArrayList<SysFunction>();//菜单具有的按钮
    private List<Integer> checkedFunctions = new ArrayList<Integer>();//该菜单被角色选中的功能ID
    private String checked;//该菜单是否被角色选中，0 为选中，1 为没选中
}
