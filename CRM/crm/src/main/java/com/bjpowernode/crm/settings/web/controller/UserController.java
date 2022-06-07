package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.pojo.ReturnObject;

import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.settings.pojo.User;
import com.bjpowernode.crm.settings.service.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {
    @Autowired
    private UserService userService;
    /**
     * requestMapping 中配置的地址和要跳转的资源地址保持一致
     * @return
     */
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){

        return "settings/qx/user/login";
    }

    /**
     *  根据用户名获取登录信息
     * @return
     */
    @RequestMapping("/settings/qx/user/login.do")
    public @ResponseBody Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request, HttpSession session, HttpServletResponse response
    ){
        // 将获取到的参数 放到 map集合中 封装信息
        Map<String,Object> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        //根据查询结果生成响应信息  将map集合放入到user对象 根据user对象来查询是否存在该信息
        User user = userService.queryUserByLoginActAndPwd(map);
        // ReturnObject 用来进行判断和标识
        ReturnObject returnObject = new ReturnObject();
        // 判断 是否可以登录 详情请见参考手册
        if (user==null){
            // 用户名不能为空
            returnObject.setCode("0");
            returnObject.setMessage("用户名或密码错误");

        }else {
            if (user.getExpireTime().compareTo(DateUtils.formartDataTime(new Date()))<0){  // 如果小于0 表示过期
                // 账户过期了
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAILSE);
                returnObject.setMessage("用户账户过期了");
            }else if ("0".equals(user.getLockState())){
                // 账户被锁定了 后者是否被前者所包含
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAILSE);
                returnObject.setMessage("账户被锁定了");
            }else if (!user.getAllowIps().contains(request.getRemoteAddr())){
                // 账户的ip地址受限了
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAILSE);
                returnObject.setMessage("账户的ip地址不安全");
            }else {  // 以上条件都不满足 则生成json对象  那么我们这里需要设置一个实体类，专门用来生成json对象
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                // 当我们登录成功之后 进行业务的编写，业务需要
                // 登录成功之后,所有业务页面 (提示:session域) 显示当前用户的名称 这里我们需要考虑用到什么域 这里要用到Session域
                // 将user数据存入到session域中 SESSION_USER 将其写为常量，方便维护
                session.setAttribute(Contants.SESSION_USER,user);

                // 判断是否确定要将密码 保存10 天
                if ("true".equals(isRemPwd)){
                    // 我们需要创建cookie值 将账号的值写入
                    Cookie c1 = new Cookie("loginAct", user.getLoginAct());
                    // 设置cookie时间记录 时间倒计时
                    c1.setMaxAge(60*60*24*10);
                    // 我们要将cookie 的值写入到浏览器中 ，也就是需要 repose 来进行响应 addCookie 将cookie写入到浏览器中、
                    response.addCookie(c1);

                    Cookie c2 = new Cookie("loginPwd", user.getLoginPwd());
                    c2.setMaxAge(60*60*24*10);
                    response.addCookie(c2);
                }else { // 如果 我们再次点击之后不保存密码 那么我们就把cookie进行删除
                    // 要删除cookie的方法 就是将cookie的生命周期设置为0 而且我们的cookie的名字要和 要删除的cookie的名字一样
                    Cookie c1 = new Cookie("loginPwd", "1");
                    // 将cookie的值设置成0 这样就可以通过浏览器进行删除
                    c1.setMaxAge(0);
                    response.addCookie(c1);

                    Cookie c2 = new Cookie("loginPwd", "1");
                    c2.setMaxAge(0);
                    response.addCookie(c2);

                }
            }
        }
        // 返回一个json对象
        return  returnObject; // 如果以上条件都不满足，则进行页面的返回
    }

    /**
     * 安全推出的功能
     * @param response
     * @param session
     * @return
     */
    @RequestMapping("/settings/qx/user/logout.do")
    public  String logout(HttpServletResponse response, HttpSession session){
        // 清空cookie  首先我们要获取到cookie
        Cookie c1 = new Cookie("loginAct", "1");
        // 设置其cookie的最大声明周期 清空cookie
        c1.setMaxAge(0);
        response.addCookie(c1);
        Cookie c2 = new Cookie("loginPwd", "1");
        c2.setMaxAge(0);
        response.addCookie(c2);

        // 销毁session invalidate(); 销毁session对象
        session.invalidate();

        // 跳转到首页 这里需要进行请求重定向 redirect 请求重定向的关键字
        return "redirect:/";
    }
}
