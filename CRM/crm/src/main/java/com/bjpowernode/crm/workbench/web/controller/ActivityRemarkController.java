package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.contants.Contants;
import com.bjpowernode.crm.commons.pojo.ReturnObject;
import com.bjpowernode.crm.commons.utils.CreateUUID;
import com.bjpowernode.crm.commons.utils.DateUtils;
import com.bjpowernode.crm.settings.pojo.User;
import com.bjpowernode.crm.workbench.pojo.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;


@Controller
public class ActivityRemarkController {
    // 创建service层对象
    @Autowired
    private ActivityRemarkService activityRemarkService;

    /**
     *  保存要创建的 市场活动备注， 这里我们在接收参数的时候就需要将其封装成为实体类对象。
     * @param remark
     * @return
     */
    @RequestMapping("/workbench/activity/saveCreateActivityRemark.do")
    @Transactional(readOnly = false)
    public @ResponseBody Object saveCreateActivityRemark(ActivityRemark remark, HttpSession session){
        User user = (User)session.getAttribute(Contants.SESSION_USER);
        // 我们要考虑后台sql语句需要几个参数 我们需要将其封装进去实体类对象中
        remark.setId(CreateUUID.getUUID());
        remark.setCreateTime(DateUtils.formartTime(new Date()));
        remark.setCreateBy(user.getId());
        remark.setEditFlag(Contants.REMARK_EDIT_FLAG_NO_EDITED);
        int res = activityRemarkService.saveActivityRemark(remark);
        // 创建 json返回
        ReturnObject  returnObject = new ReturnObject();
        // 我们进行判断 是否保存成功，如果保存成功我们将标志位改为1
        try {
            if (res>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                // 访问成功的话 我们要将对象返回,通过对象来和按键进行绑定之后 我们来进行数据的显示
                returnObject.setRetData(remark);  //  如果访问成功就返回一个对象。
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAILSE);
                returnObject.setMessage("系统忙！请稍后重试");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAILSE);
            returnObject.setMessage("系统忙！请稍后重试");
        }

            return  returnObject;
    }

    /**
     *  根据id删除市场活动备注
     * @param id
     * @return
     */
    @RequestMapping("/workbench/activity/deleteActivityRemarkById.do")
        public @ResponseBody Object deleteActivityRemarkById(String id){
            // 调用service层的方法
            int res = activityRemarkService.deleteActivityRemarkById(id);
            // 创建要返回的json对象
            ReturnObject returnObject = new ReturnObject();
            try {
                // 判断是否删除成功
                if (res>0){
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS); // 删除成功
                }else {
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAILSE);
                    returnObject.setMessage("系统忙,请稍后重试");
                }
            }catch (Exception e){
                e.printStackTrace();
                    returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAILSE);
                    returnObject.setMessage("系统忙,请稍后重试");
            }
            return  returnObject; // 将结果集返回
        }

    /**
     *  修改市场活动的备注信息
     * @param remark
     * @return
     */
    @RequestMapping("/workbench/activity/saveEditActivityRemark.do")
    public @ResponseBody Object saveEditActivityRemark(ActivityRemark remark,HttpSession session){
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        // 添加要修改备注的时间
        remark.setEditTime(DateUtils.formartTime(new Date()));
        remark.setEditBy(user.getId()); // 存用户的id,因为id不会重复,但是name可能重复
        remark.setEditFlag(Contants.REMARK_EDIT_FLAG_YES_EDITED);
        // 创建 json字符串
        ReturnObject returnObject = new ReturnObject();
        try {
            // 调用service层方法
            int res = activityRemarkService.saveEditActivityRemark(remark);
            if (res>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                // 返回市场活动的备注信息
                returnObject.setRetData(remark); //  为了刷新市场活动备注
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAILSE);
                returnObject.setMessage("系统忙,请稍后重试");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAILSE);
            returnObject.setMessage("系统忙,请稍后重试");
        }
            return returnObject;
    }

}
