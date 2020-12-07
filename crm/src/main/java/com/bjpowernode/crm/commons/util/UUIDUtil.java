package com.bjpowernode.crm.commons.util;

import java.util.UUID;

/**
 * @author 栗舜顺
 * 2020/11/13 0013
 */
public class UUIDUtil {

    public static String getUUID(){
        String UUIDStr = UUID.randomUUID().toString().replaceAll("-", "");
        return UUIDStr;
    }
}
