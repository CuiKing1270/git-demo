package com.bjpowernode.crm.settings.web.interceptor;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.settings.pojo.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *  配置拦截器 来拦截请求，防止非法用户进行访问
 */
public class loginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 获取session对象  通过请求域来获取
        HttpSession session = request.getSession();
        // 获取session域中的值
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        // 判断数据域中的值是否是空
        if (user==null){
            // 如果 user为空 那么我们将跳转到登录页面
            response.sendRedirect(request.getContextPath()); // 动态的获取要跳转的路径
            return  false;
        }
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

    }
}
