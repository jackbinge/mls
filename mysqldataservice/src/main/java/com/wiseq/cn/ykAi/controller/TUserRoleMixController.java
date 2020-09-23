package com.wiseq.cn.ykAi.controller;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.webview.SysUser;
import com.wiseq.cn.entity.ykAi.TUser;
import com.wiseq.cn.entity.ykAi.TUserRoleMix;
import com.wiseq.cn.ykAi.dao.TUserRoleMapper;
import com.wiseq.cn.ykAi.service.TUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/11/9       lipeng      原始版本
 * 文件说明:用户管理
 */
@RestController
@RequestMapping("/tUserRoleMixController")
public class TUserRoleMixController {
    @Autowired
    TUserService tUserService;

    /**
     * 启用禁用
     * @return
     */
    @PutMapping("/tUserUpdateDisabled")
    public Result tUserUpdateDisabled(@RequestBody TUser tUser) {
        return tUserService.updateDisabled(tUser);
    }

    /**
     * 逻辑删除
     * @return
     */
    @DeleteMapping("/tUserUpdateDel")
    public Result tUserUpdateDel(@RequestBody TUser tUserRole) {
        return tUserService.updateDel(tUserRole);
    }

    /**
     * 查询用户管理的主列表(用户管理+角色管理,组织管理页面主列表)
     */
    @GetMapping("/tUserMixFindList")
    public Result tUserMixFindList(@RequestParam(value = "groupId", required = false) Long groupId,
                                   @RequestParam(value = "username", required = false) String username,
                                   @RequestParam(value = "disabled", required = false) Boolean disabled,
                                   @RequestParam(value = "rdisabled", required = false) Boolean rdisabled,
                                   @RequestParam(value = "gname", required = false) String gname,
                                   @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                   @RequestParam(value = "pageSize", required = true) Integer pageSize) {
        PageInfo pageInfo = tUserService.findList(groupId, username,disabled,rdisabled,gname,pageNum, pageSize);
        return ResultUtils.success(pageInfo);
    }

    /**
     * 用户新增（包含新增用户信息+用户角色信息+用户组织信息）
     *
     * @param tUserRoleMix
     * @return
     */
    @PostMapping("/tUserRoleMixInsert")
    public Result tUserRoleMixinsert(@RequestBody TUserRoleMix tUserRoleMix) {
        return tUserService.insert(tUserRoleMix);
    }

    /**
     * 用户编辑（包含编辑用户信息+用户角色信息+用户组织信息）
     */
    @PutMapping("/tUserRoleMixUpdate")
    public Result tUserRoleMixUpdate(@RequestBody TUserRoleMix tUserRoleMix) {
        return tUserService.update(tUserRoleMix);
    }

    /**
     * 修改密码（密码铭文加密）
     */
    @PutMapping("/tUserUpdatePass")
    public Result tUserUpdatePass(@RequestBody TUser tUser) {
        return tUserService.tUserUpdatePass(tUser);
    }


    /**
     * 登录
     * @param account
     * @param password
     * @return
     */
    @GetMapping("/logOn")
    public Result logOn(@RequestParam("account") String account,@RequestParam("password")String password){
        return tUserService.tUserLogOn(account,password);
    }


    /**
     * 用户过滤器
     * @param userId
     * @return
     */
    @GetMapping("/userFilter")
    Result userFilter(@RequestParam("userId") Long userId){
        return tUserService.userFilter(userId);
    }
}
