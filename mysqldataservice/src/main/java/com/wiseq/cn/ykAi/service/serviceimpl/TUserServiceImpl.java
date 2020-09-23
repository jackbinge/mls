package com.wiseq.cn.ykAi.service.serviceimpl;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.BASE64;
import com.wiseq.cn.commons.utils.BuinessUtils;
import com.wiseq.cn.commons.utils.DES;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TUser;
import com.wiseq.cn.entity.ykAi.TUserMix;
import com.wiseq.cn.entity.ykAi.TUserRole;
import com.wiseq.cn.entity.ykAi.TUserRoleMix;
import com.wiseq.cn.utils.PageUtil;
import com.wiseq.cn.ykAi.dao.TUserMapper;
import com.wiseq.cn.ykAi.dao.TUserRoleMapper;
import com.wiseq.cn.ykAi.service.TUserService;
import jxl.biff.StringHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/8     lipeng      原始版本
 * 文件说明:  用户信息管理
 */
@Service
@Transactional
public class TUserServiceImpl implements TUserService {

    @Autowired
    TUserMapper tUserMapper;
    @Autowired
    TUserRoleMapper tUserRoleMapper;

    /**
     * 启用禁用
     *
     * @param tUser
     * @return
     */
    @Override
    public Result updateDisabled(TUser tUser) {
        this.tUserMapper.updateDisabled(tUser);
        return ResultUtils.success();
    }

    /**
     * 逻辑删除
     *
     * @param tUser
     * @return
     */
    @Override
    public Result updateDel(TUser tUser) {
        this.tUserMapper.updateDel(tUser);
        return ResultUtils.success();
    }


    /**
     * 用户信息主列表查询
     *
     * @param groupId
     * @param username
     * @param pageNum
     * @param pageSize
     * @return
     */
    @Override
    public PageInfo findList(Long groupId, String username, Boolean disabled,Boolean rdisabled,String gname, Integer pageNum, Integer pageSize) {
        if (null == pageNum) {
            pageNum = 1;
        }
        if (null == pageSize) {
            pageSize = 30;
        }
        PageUtil.pageHelper(pageNum, pageSize);
        List<TUserMix> tUserMixList = tUserMapper.findList(groupId, username, disabled,rdisabled,gname);
        PageInfo pageInfo = new PageInfo(tUserMixList);
        return pageInfo;
    }

    /**
     * 用户新增(新增用户信息+角色信息,密码加密存储，用户账号唯一)
     *
     * @param tUserRoleMix
     * @return
     */
    @Override
    public Result insert(TUserRoleMix tUserRoleMix) {
        TUser tUser = tUserRoleMix.getTUser();
        if (null != tUser) {
            //用户账号唯一性校验
            List<TUser> tUserList = tUserMapper.findExist(tUser.getAccount());
            if (tUserList.size() > 0) {
                return ResultUtils.error(-1, "该账号已存在，请勿重复创建");
            }
            String password = tUser.getPassword();
            password = DES.md5(password);
            tUser.setPassword(password);
            tUserMapper.insert(tUser);
        }
        TUserRole tUserRole = tUserRoleMix.getTUserRole();
        if (null != tUserRole) {
            tUserRole.setUserId(tUser.getId());
            tUserRoleMapper.insert(tUserRole);
        }
        return ResultUtils.success();
    }

    /**
     * 角色修改(用户姓名修改+组织ID+角色ID修改)
     *
     * @param tUserRoleMix
     * @return
     */
    @Override
    public Result update(TUserRoleMix tUserRoleMix) {
        //先修改用户信息
        TUser tUser = tUserRoleMix.getTUser();
        if (null != tUser) {
            tUserMapper.updateUser(tUser);
        }
        //修改角色信息
        TUserRole tUserRole = tUserRoleMix.getTUserRole();
        if (null != tUserRole) {
//            tUserRole.setUserId(tUser.getId());
            tUserRole.setUserId(tUser.getId());
            tUserRoleMapper.updateUserRole(tUserRole);
        }
        return ResultUtils.success();
    }

    /**
     * 重置密码
     */
    @Override
    public Result tUserUpdatePass(TUser tUser) {
        if (null != tUser) {
            String password = tUser.getPassword();
            password = DES.md5(password);
            tUser.setPassword(password);
            tUserMapper.updatePass(tUser);
        }
        return ResultUtils.success();
    }

    @Override
    public Result tUserLogOn(String account, String password) {
        if(password==null || password ==""){
            return ResultUtils.error(1,"密码不能为空");
        }
        if(account== null ||account == ""){
            return ResultUtils.error(1,"账户不能为空");
        }

        List<TUser> tUserList = this.tUserMapper.findUserByAccount(account);
        if(tUserList.size()== 0){
            return ResultUtils.error(1,"该账户不存在");
        }
        for (TUser t:
         tUserList) {
            if(t.getDisabled()== true){
                return ResultUtils.error(1,"该账户已被禁用");
            }
        }
        String decodePassword = new String(new BASE64().decode(password));
        if(!BuinessUtils.isPassword(decodePassword)){
            return ResultUtils.error(1,"密码不符合要求");
        };
        String mD5Password = DES.md5(decodePassword);
        TUser tUser = tUserMapper.findUserByAccountAndPassword(account,mD5Password);

        if(tUser == null){
            return ResultUtils.error(1,"用户名或密码有误");
        }
        Integer  num = tUserMapper.findRoleByUser(tUser.getId());
        if(num == 0){
            return ResultUtils.error(1,"该用户没有可用角色无法登录");
        }
        return ResultUtils.success(tUser);
    }

    @Override
    public Result userFilter(Long userId){
       TUser tUser = this.tUserMapper.findUserById(userId);
       if(null == tUser || tUser.getIsDelete() ){
           return ResultUtils.error(999,"用户不存在");
       }
       if(tUser.getDisabled()){
           return ResultUtils.error(999,"用户被禁用");
       }
       return ResultUtils.success();
    }
}
