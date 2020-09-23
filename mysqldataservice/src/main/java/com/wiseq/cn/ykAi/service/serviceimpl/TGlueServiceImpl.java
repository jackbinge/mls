package com.wiseq.cn.ykAi.service.serviceimpl;

import com.github.pagehelper.PageInfo;
import com.wiseq.cn.entity.ykAi.TABGlue;
import com.wiseq.cn.entity.ykAi.TGlue;
import com.wiseq.cn.utils.PageUtil;
import com.wiseq.cn.ykAi.dao.TGlueDao;
import com.wiseq.cn.ykAi.service.TGlueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/31       lipeng      原始版本
 * 文件说明:  原材料库-胶水信息
 */
@Service
public class TGlueServiceImpl implements TGlueService {

    @Autowired
    TGlueDao tGlueMapper;
    /**
     * 逻辑删除
     *
     * @param tGlue
     * @return
     */
    @Override
    public int updateDel(TGlue tGlue) {
        int flag = tGlueMapper.updateDel(tGlue);
        return flag;
    }

    /**
     * 启用禁用
     *
     * @param tGlue
     * @return
     */
    @Override
    public int updateDisabled(TGlue tGlue) {
        int flag = tGlueMapper.updateDisabled(tGlue);
        return flag;
    }


    @Override
    public PageInfo findList(String glueSpec, Boolean disabled, Integer pageNum, Integer pageSize) {
        if (null == pageNum) {
            pageNum = 1;
        }
        if (null == pageSize) {
            pageSize = 30;
        }
        PageUtil.pageHelper(pageNum, pageSize);
        List<TABGlue> tABGlueList = tGlueMapper.findList(glueSpec, disabled);
        PageInfo pageInfo = new PageInfo(tABGlueList);
        return pageInfo;
    }
}
