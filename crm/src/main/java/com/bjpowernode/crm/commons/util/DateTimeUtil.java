package com.bjpowernode.crm.commons.util;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @author 栗舜顺
 * 2020/11/11 0011
 */
public class DateTimeUtil {

    public static String getFormatDateTime(Date date){
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String formatStr = sdf.format(date);
        return formatStr;
    }

    public static String formateDateTimeYYYYMMDDHHMMSS(Date date) {
        SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMddHHmmss");
        String formatStr = sdf.format(date);
        return formatStr;
    }
}
