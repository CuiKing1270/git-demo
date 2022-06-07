package com.bjpowernode.crm.commons.pojo;
// 专门用来返回json字符串
public class ReturnObject {
    private String code; // 用来判断标志， 1 表示成功 0 表示失败
    private String message; // 提示信息
    private Object retData; // 其他数据

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getRetData() {
        return retData;
    }

    public void setRetData(Object retData) {
        this.retData = retData;
    }
}
