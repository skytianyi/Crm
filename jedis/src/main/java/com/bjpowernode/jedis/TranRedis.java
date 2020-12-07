package com.bjpowernode.jedis;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.Transaction;

/**
 * @author 栗舜顺
 * 2020/12/7 0007
 */
public class TranRedis {
    public static void main(String[] args) {
        //1.建立连接
        Jedis jedis = new Jedis("192.168.211.132",6379);
        //2.获取Transaction对象 可以把一组命令压入队列
        Transaction transaction=jedis.multi();
        transaction.set("k2", "k2");
        transaction.set("k3", "k3");
//        transaction.discard();
        transaction.exec();


    }
}
