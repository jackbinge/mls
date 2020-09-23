package com.wiseq.cn.ykAi.service.serviceimpl;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TPrivilege;
import com.wiseq.cn.ykAi.dao.TPrivilegeDao;
import com.wiseq.cn.ykAi.service.TPrivilegeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/8     lipeng      原始版本
 * 文件说明:  
 */
@Service
public class TPrivilegeServiceImpl implements TPrivilegeService {

    @Autowired
    TPrivilegeDao tPrivilegeDao;

    /**
     * 获取树结构
     * @return
     */
    @Override
    public Result getBaseTree(){
        return ResultUtils.success(this.tPrivilegeDao.getBaseTree());
    }

    /**
     * 获得用户的树结构
     * @param userId
     * @return
     */
    @Override
    public Result getUserTree(Long userId) {
        return ResultUtils.success(this.tPrivilegeDao.getUserTree(userId));
    }
}
