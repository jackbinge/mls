package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.RoleEdit;
import com.wiseq.cn.entity.ykAi.TGroup;
import com.wiseq.cn.entity.ykAi.TRole;
import com.wiseq.cn.ykAi.service.servicefbk.TRolePrivilegeButtonServiceFbk;
import io.swagger.annotations.ApiOperation;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:组织页面
 */
@FeignClient(value = "mysqldata-service/tRolePrivilegeButtonController", fallback = TRolePrivilegeButtonServiceFbk.class)
public interface TRolePrivilegeButtonService {

    /**
     * 角色启用禁用
     */
    @PutMapping("/tRolePrivilegeButtonDisabled")
    public Result tRolePrivilegeButtonDisabled(@RequestParam("roleId") Long roleId,@RequestParam("disable") Boolean disable);



    /**
     * 角色删除为真删除
     */
    @DeleteMapping("/tRolePrivilegeButtonUpdateDel")
    public Result tRolePrivilegeButtonUpdateDel(@RequestParam("roleId")Long  roleId);


    /**
     * 通过组织ID查询角色管理主页面
     */
    @GetMapping("/tRolePrivilegeButtonFindList")
    @ApiOperation(value = "通过组织Id查询该组织下的角色名称")
    public Result tRolePrivilegeButtonFindList(@RequestParam(value = "name", required = false) String name,
                                               @RequestParam(value = "disabled", required = false) Boolean disabled,
                                               @RequestParam(value = "groupId", required = true) Long groupId,
                                               @RequestParam(value = "pageNum", required = true) Integer pageNum,
                                               @RequestParam(value = "pageSize", required = true) Integer pageSize);


    /**
     * 角色的编辑
     * @param roleEdit
     * @return
     */
    @PutMapping("/edit")
    @ApiOperation("角色的新增和编辑")
    Result edit(@RequestBody  RoleEdit roleEdit);
}
