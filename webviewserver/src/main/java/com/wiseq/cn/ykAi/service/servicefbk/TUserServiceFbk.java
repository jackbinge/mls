package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TUser;
import com.wiseq.cn.entity.ykAi.TUserRoleMix;
import com.wiseq.cn.ykAi.service.TUserService;
import org.springframework.stereotype.Service;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原组织
 */
@Service
public class TUserServiceFbk implements TUserService {

    @Override
    public Result tUserUpdateDisabled(TUser tUser) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result tUserUpdateDel(TUser tUserRole) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result tUserMixFindList(Long groupId, String username, Boolean disabled, Boolean rdisabled, String gname, Integer pageNum, Integer pageSize) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result tUserRoleMixinsert(TUserRoleMix tUserRoleMix) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result tUserRoleMixUpdate(TUserRoleMix tUserRoleMix) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result tUserUpdatePass(TUser tUser) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result logOn(String uname, String password) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result userFilter(Long userId) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }


}
