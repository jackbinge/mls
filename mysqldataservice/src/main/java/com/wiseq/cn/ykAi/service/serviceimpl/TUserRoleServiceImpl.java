package com.wiseq.cn.ykAi.service.serviceimpl;

import com.wiseq.cn.entity.ykAi.TUserRole;
import com.wiseq.cn.ykAi.dao.TUserRoleMapper;
import com.wiseq.cn.ykAi.service.TUserRoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/8     lipeng      原始版本
 * 文件说明:  
 */
@Service
public class TUserRoleServiceImpl implements TUserRoleService {

    @Autowired
    TUserRoleMapper tUserRoleMapper;


}
