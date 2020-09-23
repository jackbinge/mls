package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.RoleEdit;
import com.wiseq.cn.entity.ykAi.TGroup;
import com.wiseq.cn.entity.ykAi.TRole;
import com.wiseq.cn.ykAi.service.TRolePrivilegeButtonService;
import org.springframework.stereotype.Service;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:组织页面
 */
@Service
public class TRolePrivilegeButtonServiceFbk implements TRolePrivilegeButtonService {

    @Override
    public Result tRolePrivilegeButtonDisabled(Long roleId, Boolean disable) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result tRolePrivilegeButtonUpdateDel(Long roleId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result tRolePrivilegeButtonFindList(String name, Boolean disabled, Long groupId, Integer pageNum, Integer pageSize) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result edit(RoleEdit roleEdit) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
