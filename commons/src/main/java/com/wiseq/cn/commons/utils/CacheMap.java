package com.wiseq.cn.commons.utils;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class CacheMap {
    
    private static Map<String,Object> cache = new ConcurrentHashMap<String, Object>();
    
    public static void put(String key, Object obj){
        cache.put(key,obj);
    }
    
    public static Object get(String key){
         return cache.get(key);
    }
    
    public static  void remove(String key){
        cache.remove(key);
    }
}