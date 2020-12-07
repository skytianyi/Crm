package com.bjpowernode.jedis;


import redis.clients.jedis.Jedis;

import java.util.Set;

/**
 * @author 栗舜顺
 * 2020/12/7 0007
 */
public class FirstJedis {
    public static void main(String[] args) {
        //连接redis
        Jedis jedis = new Jedis("192.168.211.132",6379);
//        Set<String> keys = jedis.keys("*");
//        for (String key :keys) {
//            System.out.print(key+" ");
//        }
//        System.out.println();
//
//        jedis.flushDB();

//        jedis.set("k1", "v1");
       /* String value = jedis.get("k1");
        System.out.println(value);

        String v2 = jedis.get("v2");
        System.out.println(v2);*/
       jedis.select(1);

       jedis.set("k1", "v1");
        String k1 = jedis.get("k1");
        System.out.println(k1);

        System.out.println("项目经理提交更新代码");

    }
}
