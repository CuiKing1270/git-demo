package com.bjpowernode.crm.commons.utils;


import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 对Data类型数据进行处理的工具类
 */
public class DateUtils {
    // 将日期进行格式化

    /**
     *  进行指定的格式化
     * @param date
     * @return
     */
    public static String formartDataTime(Date date){
        SimpleDateFormat std = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String format = std.format(date);
        return format;
    }

    /**
     *  对 年月日 格式化
     * @param date
     * @return
     */
    public static String formartData(Date date){
        SimpleDateFormat std = new SimpleDateFormat("yyyy-MM-dd");
        String format = std.format(date);
        return format;
    }

    /**
     *  对 时分秒进行格式化
     * @param date
     * @return
     */
    public static String formartTime(Date date){
        SimpleDateFormat std = new SimpleDateFormat("HH:mm:ss");
        String format = std.format(date);
        return format;
    }

}
