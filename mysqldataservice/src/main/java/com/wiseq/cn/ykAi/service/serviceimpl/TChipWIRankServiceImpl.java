package com.wiseq.cn.ykAi.service.serviceimpl;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.QuHelper;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TChipWlRank;
import com.wiseq.cn.ykAi.dao.TChipWlRankDao;
import com.wiseq.cn.ykAi.service.TChipWlRankService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 版本        修改时间        作者      修改内容
 * V1.0     2019/10/29       lipeng      原始版本
 * 文件说明:原材料库-波段
 */
@Service
public class TChipWIRankServiceImpl implements TChipWlRankService {
    @Autowired
    TChipWlRankDao tChipWlRankMapper;


    /**
     * 查询波段信息列表
     *
     * @return
     */
    @Override
    public Result findAll(Long chipId) {
         List<TChipWlRank> result = tChipWlRankMapper.findAll(chipId);
        return ResultUtils.success(result);
    }
}
