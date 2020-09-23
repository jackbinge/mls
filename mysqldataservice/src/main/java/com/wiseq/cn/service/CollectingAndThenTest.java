package com.wiseq.cn.service;

import com.google.common.collect.Lists;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.TreeSet;
import java.util.stream.Collectors;

/**
 * 版本          修改时间      作者       修改内容
 * V1.0         2019/12/3     jiangbailing      原始版本
 * 文件说明:
 */
public class CollectingAndThenTest {

    static void  testCollectingAndThen() {

        UserOrder order0 = new UserOrder("年会", "张三", "box0001");
        UserOrder order1 = new UserOrder("婚庆", "张三", "box0002");
        UserOrder order2 = new UserOrder("旅游", "李四", "box0003");
        UserOrder order3 = new UserOrder("发布会", "张三", "box0002");
        UserOrder order4 = new UserOrder("旅游", "李四", "box0004");

        List<UserOrder> list = Lists.newArrayList(order0, order1, order2, order3, order4);

        System.out.println("=====>只根据单一属性photographerName进行去重");
        // <R, A> R collect(Collector<? super T, A, R> collector);
        // collectingAndThen(Collector<T, A, R> downstream, Function<R, RR> finisher)
        // toCollection(Supplier<C> collectionFactory)
        ArrayList<UserOrder> distinctByName = list.stream()
                .collect(
                        Collectors.collectingAndThen(
                                Collectors.toCollection(() -> new TreeSet<>(Comparator.comparing(UserOrder::getPhotographerName))),
                                userOrders -> new ArrayList<>(userOrders)
                        )
                );
        distinctByName.forEach(System.out::println);

        System.out.println("=====>同时根据photographerName和deviceCode两个属性进行去重");
        ArrayList<UserOrder> distinctByNameAndCode = list.stream()
                .collect(
                        Collectors.collectingAndThen(
                                Collectors.toCollection(() -> new TreeSet<>(Comparator.comparing(userOrder -> userOrder.getPhotographerName() + userOrder.getDeviceCode()))),
                                ArrayList::new
                        )
                );
        distinctByNameAndCode.forEach(System.out::println);
    }

    public static void main(String[] args) {
        testCollectingAndThen();
    }

}
