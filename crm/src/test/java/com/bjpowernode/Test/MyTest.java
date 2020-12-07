package com.bjpowernode.Test;

import com.bjpowernode.crm.commons.util.MD5Util;
import org.junit.Test;

/**
 * @author 栗舜顺
 * 2020/11/13 0013
 */
public class MyTest {

    @Test
    public void test(){
        String md5 = MD5Util.getMD5("123");
        System.out.println(md5);
    }
}
