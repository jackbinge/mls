package com.wiseq.cn.ykAi.controller;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.RoleEdit;
import com.wiseq.cn.ykAi.service.TRolePrivilegeButtonService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:角色管理页面
 */
@RestController
@RequestMapping("/tRolePrivilegeButtonController")
@Api(description = "角色管理页面")
public class TRolePrivilegeButtonController {
    @Autowired
    TRolePrivilegeButtonService tRolePrivilegeButtonService;

    /**
     * 角色启用禁用
     */
    @PutMapping("/tRolePrivilegeButtonDisabled")
    public Result tRolePrivilegeButtonDisabled(@RequestParam("roleId") Long roleId,@RequestParam("disable") Boolean disable) {
        return this.tRolePrivilegeButtonService.tRolePrivilegeButtonDisabled(roleId, disable);
    }


    /**
     * 角色删除为真删除
     */
    @DeleteMapping("/tRolePrivilegeButtonUpdateDel")
    public Result tRolePrivilegeButtonUpdateDel(@RequestParam("roleId")Long  roleId) {
        return this.tRolePrivilegeButtonService.tRolePrivilegeButtonUpdateDel(roleId);
    }


    /**
     * 通过组织ID查询角色管理主页面
     */
    @GetMapping("/tRolePrivilegeButtonFindList")
    @ApiOperation(value = "通过组织Id查询该组织下的角色名称")
    public Result tRolePrivilegeButtonFindList(@RequestParam(value = "name", required = false) String name,
                                               @RequestParam(value = "disabled", required = false) Boolean disabled,
                                               @RequestParam(value = "groupId", required = true) Long groupId,
                                               @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                               @RequestParam(value = "pageSize", required = true) Integer pageSize) {
        return tRolePrivilegeButtonService.tRolePrivilegeButtonFindList(name, disabled, groupId, pageNum, pageSize);

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
