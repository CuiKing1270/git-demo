package com.bjpowernode.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
 // 要跳转的工作台的controller
@Controller
public class MainController {
    // 编写跳转网页的方法  请求映射的文件地址要和要跳转的资源的路径地址保持一致
    @RequestMapping("/workbench/main/index.do")
    public String index(){
        return "workbench/main/index";
    }
}
