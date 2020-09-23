package com.wiseq.cn.ykAi.service.serviceimpl;


import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.exception.QuException;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.*;
import com.wiseq.cn.utils.PageUtil;
import com.wiseq.cn.ykAi.dao.TRoleMapper;
import com.wiseq.cn.ykAi.dao.TRolePrivilegeMapper;
import com.wiseq.cn.ykAi.dao.TUserRoleMapper;
import com.wiseq.cn.ykAi.service.TRolePrivilegeButtonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/9/10       lipeng      原始版本
 * 文件说明:角色菜单按钮配置管理
 */
@Service
public class TRolePrivilegeButtonServiceImpl implements TRolePrivilegeButtonService {
    @Autowired
    TRoleMapper tRoleMapper;
    @Autowired
    TUserRoleMapper tUserRoleMapper;
    @Autowired
    TRolePrivilegeMapper tRolePrivilegeMapper;

    /**
     * 禁用和启用
     * @param roleId
     * @param disable
     * @return
     */
    @Override
    public int updateDisabled(Long roleId, Boolean disable) {
        return this.tRoleMapper.disable(roleId, disable);
    }

    /**
     * 删除当前组织下的角色(删除时判断该角色下是否还有人员)
     *
     * @param roleId
     * @return
     */
    @Override
    public int updateDel(Long roleId) {
       /* List<TUserRole> tUserRoleList = tUserRoleMapper.findExit(roleId);
        if (tUserRoleList.size() > 0) {
            throw new QuException(-1, "当前角色下仍有人员，不可删除");
        }*/
        return this.tRoleMapper.deleteRoleAndPrivilege(roleId);
    }

    /**
     * 查询角色管理主页面数据
     * @param name
     * @param disabled
     * @param pageNum
     * @param pageSize
     * @return
     */
    @Override
    public PageInfo findList(String name, Boolean disabled,Long groupId, Integer pageNum, Integer pageSize) {
        PageUtil.pageHelper(pageNum, pageSize);
        List<TRoleGroup> findRoleGroupList = tRoleMapper.findList(name,disabled,groupId);
        PageInfo pageInfo = new PageInfo(findRoleGroupList);
        return pageInfo;
    }

    /**
     * 编辑
     * @param roleEdit
     * @return
     */
    @Override
    @Transactional
    public Result edit(RoleEdit roleEdit) {
        TRole tRole = roleEdit.getTRole();
        if(null==tRole.getId()){
            return roleAdd(roleEdit);
        }
        return roleUpdate(roleEdit);
    }

    /**
     * 新增
     * @param roleEdit
     * @return
     */
    @Transactional
    Result roleAdd(RoleEdit roleEdit){
        TRole tRole = roleEdit.getTRole();
        List<Long> privileges = roleEdit.getPrivileges();
        List<TRolePrivilege> tRolePrivileges = new ArrayList<>();
        int num = tRoleMapper.findRoleExit(tRole.getName(),tRole.getGroupId(),null);
        if(num > 0){
            return ResultUtils.error(1,"该组织下角色名重复");
        }
        //新增角色
        this.tRoleMapper.insertSelective(tRole);
        //新增新的权限
        for (Long p:
                privileges) {
            TRolePrivilege tRolePrivilege = new TRolePrivilege();
            tRolePrivilege.setPrivilegeId(p);
            tRolePrivilege.setRoleId(tRole.getId());
            tRolePrivileges.add(tRolePrivilege);
        }
        tRoleMapper.batchInsertRoleWithPrivilege(tRolePrivileges);
        return ResultUtils.success();
    }


    /**
     * 修改
     * @param roleEdit
     * @return
     */
    @Transactional
    Result roleUpdate(RoleEdit roleEdit){
        TRole tRole = roleEdit.getTRole();
        List<Long> privileges = roleEdit.getPrivileges();
        List<TRolePrivilege> tRolePrivileges = new ArrayList<>();
        int num = tRoleMapper.findRoleExit(tRole.getName(),tRole.getGroupId(),tRole.getId());
        if(num > 0){
            return ResultUtils.error(1,"该组织下角色名重复");
        }
        //修改角色
        tRoleMapper.updateByPrimaryKeySelective(tRole);
        //删除原有的权限
        tRoleMapper.deleteRolePrivilege(tRole.getId());
        //新增新的权限
        for (Long p:
                privileges) {
            TRolePrivilege tRolePrivilege = new TRolePrivilege();
            tRolePrivilege.setPrivilegeId(p);
            tRolePrivilege.setRoleId(tRole.getId());
            tRolePrivileges.add(tRolePrivilege);
            //tRolePrivilegeMapper.insertSelective(tRolePrivilege);
        }
        tRoleMapper.batchInsertRoleWithPrivilege(tRolePrivileges);
        return ResultUtils.success();
    }


}

