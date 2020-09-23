package com.wiseq.cn;


import com.wiseq.cn.commons.utils.ResultUtils;
import com.wiseq.cn.entity.ykAi.TAlgorithmModel;
import com.wiseq.cn.mysqldataservice.MysqldataserviceApplication;
import org.apache.poi.ss.formula.functions.T;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

@RunWith(SpringRunner.class)
@SpringBootTest(classes = MysqldataserviceApplication.class)
//由于是Web项目，Junit需要模拟ServletContext，因此我们需要给我们的测试类加上@WebAppConfiguration。
@WebAppConfiguration
public class TmallApplicationTests {
    @Before
    public void init() {
        System.out.println("开始测试-----------------");
    }

    @Test
    public void test1(){
        Long a = 1l;
        Long b = 2l;
        Long c = 3l;
        Long d = 4l;
        Double e = 1.01;
        Long aa = 1l;
        Long bb = 2l;
        Long cc = 3l;
        Long dd = 4l;
        Double ee = 1.01;
//
//        if(a == aa && b == bb && c == cc && d == dd && e.equals(ee)){
//            System.out.println("进入if啦----------");
//        }else{
//            System.out.println("没有进入if啦============");
//        }

        TAlgorithmModel tam = new TAlgorithmModel();
        TAlgorithmModel ta = new TAlgorithmModel();
        tam.setScaffoldId(a);
        tam.setChipId(b);
        tam.setCt(c);
        tam.setP1Id(d);
        tam.setARatio(e);

        ta.setScaffoldId(a);
        ta.setChipId(b);
        ta.setCt(c);
        ta.setP1Id(d);
        ta.setARatio(e);

        if(tam.getScaffoldId() == ta.getScaffoldId() && tam.getChipId() == ta.getChipId() && tam.getCt() == ta.getCt() && tam.getP1Id() == ta.getP1Id() && tam.getARatio().equals(ta.getARatio())){
            System.out.println("进入if啦----------");
        }else{
            System.out.println("没有进入if啦============");
        }

    }

    @After
    public void after() {
        System.out.println("测试结束-----------------");
    }
}
