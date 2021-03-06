package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TUser;
import com.wiseq.cn.entity.ykAi.TUserRoleMix;
import com.wiseq.cn.ykAi.service.servicefbk.TUserServiceFbk;
import io.swagger.annotations.ApiOperation;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:组织
 */
@FeignClient(value = "mysqldata-service/tUserRoleMixController", fallback = TUserServiceFbk.class)
public interface TUserService {
    /**
     * 启用禁用
     * @return
     */
    @PutMapping("/tUserUpdateDisabled")
    @ApiOperation(value = "用户启用禁用")
    public Result tUserUpdateDisabled(@RequestBody TUser tUser);

    /**
     * 逻辑删除
     * @return
     */
    @DeleteMapping("/tUserUpdateDel")
    @ApiOperation(value = "用户逻辑删除")
    public Result tUserUpdateDel(@RequestBody TUser tUserRole);

    /**
     * 查询用户管理的主列表(用户管理+角色管理,组织管理页面主列表)
     */
    @GetMapping("/tUserMixFindList")
    @ApiOperation(value = "查询用户管理的主列表(用户管理+角色管理,组织管理页面主列表)")
    public Result tUserMixFindList(@RequestParam(value = "groupId", required = false) Long groupId,
                                   @RequestParam(value = "username", required = false) String username,
                                   @RequestParam(value = "disabled", required = false) Boolean disabled,
                                   @RequestParam(value = "rdisabled", required = false) Boolean rdisabled,
                                   @RequestParam(value = "gname", required = false) String gname,
                                   @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                   @RequestParam(value = "pageSize", required = true) Integer pageSize);

    /**
     * 用户新增（包含新增用户信息+用户角色信息+用户组织信息）
     *
     * @param tUserRoleMix
     * @return
     */
    @PostMapping("/tUserRoleMixInsert")
    @ApiOperation(value = "用户新增（包含新增用户信息+用户角色信息+用户组织信息）")
    public Result tUserRoleMixinsert(@RequestBody TUserRoleMix tUserRoleMix);
    /**
     * 用户编辑（包含编辑用户信息+用户角色信息+用户组织信息）
     */
    @PutMapping("/tUserRoleMixUpdate")
    @ApiOperation(value = "用户编辑（包含编辑用户信息+用户角色信息+用户组织信息）")
    public Result tUserRoleMixUpdate(@RequestBody TUserRoleMix tUserRoleMix);

    /**
     * 修改密码（密码铭文加密）
     */
    @PutMapping("/tUserUpdatePass")
    @ApiOperation(value = "修改密码（密码铭文加密）")
    public Result tUserUpdatePass(@RequestBody TUser tUser);



    @GetMapping("/logOn")
    public Result logOn(@RequestParam("account") String account,@RequestParam("password")String password);

    @GetMapping("/userFilter")
    public Result userFilter(@RequestParam("userId") Long userId);
}
