package com.wiseq.cn.ykAi.controller;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.RoleEdit;
import com.wiseq.cn.utils.OperatingUtil;
import com.wiseq.cn.ykAi.service.TRolePrivilegeButtonService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/11/12       lipeng      原始版本
 * 文件说明:角色菜单按钮配置管理
 */
@RestController
@RequestMapping("/tRolePrivilegeButtonController")
@Api("角色权限管理")
public class TRolePrivilegeButtonController {
    @Autowired
    TRolePrivilegeButtonService tRolePrivilegeButtonService;

    /**
     * 角色启用禁用
     */
    @PutMapping("/tRolePrivilegeButtonDisabled")
    public Result tRolePrivilegeButtonDisabled(@RequestParam("roleId") Long roleId,@RequestParam("disable") Boolean disable) {
        int flag = tRolePrivilegeButtonService.updateDisabled(roleId, disable);
        return OperatingUtil.updateDeal(flag);
    }


    /**
     * 角色删除为真删除
     */
    @DeleteMapping("/tRolePrivilegeButtonUpdateDel")
    public Result tRolePrivilegeButtonUpdateDel(@RequestParam("roleId")Long  roleId) {
        int flag = tRolePrivilegeButtonService.updateDel(roleId);
        return OperatingUtil.updateDeal(flag);
    }

    /**
     * 通过组织ID查询角色管理主页面
     */
    @GetMapping("/tRolePrivilegeButtonFindList")
    public Result tRolePrivilegeButtonFindList(@RequestParam(value = "name", required = false) String name,
                                               @RequestParam(value = "disabled", required = false) Boolean disabled,
                                               @RequestParam(value = "groupId", required = true) Long groupId,
                                               @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                               @RequestParam(value = "pageSize", required = true) Integer pageSize) {
        PageInfo pageInfo = tRolePrivilegeButtonService.findList(name, disabled, groupId, pageNum, pageSize);
        return ResultUtils.success(pageInfo);
    }


    /**
     * 角色的编辑
     * @param roleEdit
     * @return
     */
    @PutMapping("/edit")
    @ApiOperation("角色的新增和编辑")
    Result edit(@RequestBody RoleEdit roleEdit){
        return tRolePrivilegeButtonService.edit(roleEdit);
    }

}
