package com.wiseq.cn.ykAi.service;

import com.wiseq.cn.commons.entity.Result;
import org.springframework.stereotype.Service;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/9/10       lipeng      原始版本
 * 文件说明:组织结构
 */
@Service
public interface TPrivilegeService {
    /**
     * 获取树结构
     * @return
     */
    Result getBaseTree();

    /**
     * 获得用户的权限树
     * @return
     */
    Result getUserTree(Long userId);
}
