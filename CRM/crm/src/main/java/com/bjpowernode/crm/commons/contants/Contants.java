package com.bjpowernode.crm.commons.contants;

public class Contants {
    // 常量类  用来判断 标志位 是否可以登录成功
    public final  static  String RETURN_OBJECT_CODE_SUCCESS = "1"; // 成功
    public final  static  String RETURN_OBJECT_CODE_FAILSE = "0"; // 失败

    // 将session数据放入到 常量类中
    public final  static String SESSION_USER = "sessionUser";

    // 备注的修改标记
    public final static String REMARK_EDIT_FLAG_NO_EDITED="0"; //0-- 没有修改过
    public final static String REMARK_EDIT_FLAG_YES_EDITED="1"; //1-- 修改过
}
