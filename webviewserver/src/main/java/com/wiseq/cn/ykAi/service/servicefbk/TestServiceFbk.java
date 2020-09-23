package com.wiseq.cn.ykAi.service.servicefbk;

import com.wiseq.cn.commons.entity.Result;
import com.wiseq.cn.commons.enums.ResultEnum;
import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.ykAi.service.TestService;
import org.springframework.stereotype.Service;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/11/19     jiangbailing      原始版本
 * 文件说明: 测试接口
 */
@Service
public class TestServiceFbk implements TestService {
    @Override
    public Result getTest() {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }

    @Override
    public Result getHelloTest(Long id) {
        return ResultUtils.error(ResultEnum.NETWORK_ERR);
    }
}
