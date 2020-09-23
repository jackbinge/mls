package com.wiseq.cn.ykAi.service;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TUser;
import com.wiseq.cn.entity.ykAi.TUserRoleMix;

/**
* 版本        修改时间        作者      修改内容
* V1.0     2019/10/31       lipeng      原始版本
* 文件说明:  角色信息
*/
public interface TUserService {

    Result updateDisabled(TUser tUser);

    Result updateDel(TUser tUserRole);

    PageInfo findList(Long groupId, String username,Boolean disabled,Boolean rdisabled,String gname, Integer pageNum, Integer pageSize);

    Result insert(TUserRoleMix tUserRoleMix);

    Result update(TUserRoleMix tUserRoleMix);

    Result tUserUpdatePass(TUser tUser);

    Result tUserLogOn(String account,String password);

    Result userFilter(Long userId);
}
