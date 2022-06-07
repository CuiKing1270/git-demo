package com.bjpowernode.crm.commons.utils;

import java.util.UUID;

/**
 *  用来生成UUID
 */
public class CreateUUID {
    public static String getUUID(){
        // randomUUID 表示用来随机生成一个UUID  36位 其中有四位为 -
        // toString  表示用来将生成的UUID 转化为字符串
        // replaceAll  表示用来替换所有的字符串
        return UUID.randomUUID().toString().replaceAll("-","");
    }
}
