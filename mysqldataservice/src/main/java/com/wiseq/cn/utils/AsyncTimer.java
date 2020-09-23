package com.wiseq.cn.utils;

//import com.wiseq.cn.epitop.service.ZlCheckCraftService;
//import com.wiseq.cn.epitop.service.ZlCheckEnvService;
//import com.wiseq.cn.epitop.service.ZlCheckFacaeService;
//import com.wiseq.cn.epitop.service.ZlCheckSevenService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * 版本        修改时间        作者        修改内容
 * V1.0        ------        wangyh       原始版本
 * 文件说明: AsyncTimer
 **/
@Component
@EnableScheduling
@EnableAsync
public class AsyncTimer {

//    @Autowired
//    private ZlCheckCraftService zlCheckCraftService;
//    @Autowired
//    private ZlCheckSevenService zlCheckSevenService;
//    @Autowired
//    private ZlCheckEnvService zlCheckEnvService;
//    @Autowired
//    private ZlCheckFacaeService zlCheckFacaeService;
//
//    /**
//     * 更新检验记录
//     */
//    @Async
//    @Scheduled(cron = "0 0 0/1 * * ?")
//    public void updateCheck(){
//        zlCheckCraftService.addCheckRecord();
//        zlCheckSevenService.addCheckRecord();
//        zlCheckEnvService.addCheckRecord();
//        zlCheckFacaeService.addCheckRecord();
//    }
}
