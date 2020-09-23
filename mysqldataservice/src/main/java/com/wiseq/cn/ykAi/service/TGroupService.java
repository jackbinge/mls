package com.wiseq.cn.ykAi.service;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.entity.ykAi.TChip;
import com.wiseq.cn.entity.ykAi.TGroup;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/9/10       lipeng      原始版本
 * 文件说明:组织结构
 */
public interface TGroupService {

    Result findGroupTree(String code, String name);

    Result insert(TGroup tGroup);

    Result tGroupDel(TGroup tGroup);

    Result findProductionCodeList(Long id);

    Result findProductionNoCode();

    Result productionCodeinsert(TGroup tGroup);

    Result productionCodeUpdate(TGroup tGroup);

    Result productionShopList();

    /**
     * 获取没有EAS编码的工厂列表
     * @return
     */
    Result getNoMapEasIdShopList();



    Result updateGroupEasId(String mapEasId, Long id);

    Result getProductionMapEASIdList(Long id, Integer pageNum, Integer pageSize);

//    Result findTGroupUserRoleList(String groupId, String username);
}
