package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.pojo.Activity;

import java.text.AttributedCharacterIterator;
import java.util.List;
import java.util.Map;

public interface ActivityService {
    /**
     *  调用mapper层来进行对象的创建 int 返回值类型表示影响的行数
     * @param activity
     * @return
     */
    int SaveCreateActivity(Activity activity);

    /**
     * 根据条件查询 用户信息 来显示到列表中
     * @param map map集合中 String类型表示的是键 因为我们json只能解析字符串类型
     * @return
     */
    List<Activity> queryActivityByConditionForPage(Map<String,Object> map);

    /**
     *  根据条件查询 用户记录总条数
     * @param map
     * @return
     */
    int queryCountOfActivityByCondition(Map<String,Object> map);

    /**
     *  根据id进行删除。
     * @param ids
     * @return
     */
    int deleteActivityByIds(String[] ids);

    /**
     *  修改市场活动第一步
     * @param id
     * @return
     */
    Activity queryActivityById(String id);

    /**
     *  修改市场活动第二步
     * @param activity
     * @return
     */
    int saveEditActivity(Activity activity);

    /**
     *  导出 市场活动  首先要修改所有的市场活动
     * @return
     */
    List<Activity> queryAllActivitys();

    /**
     *  选择性 导出市场活动
     * @return
     */
    List<Activity> queryCheckedActivity(String[] ids);

    /**
     *  导入市场活动
     * @param activityList
     * @return
     */
    int saveCreateActivityByList(List<Activity> activityList);

    /**
     *  第一步
     *  查看市场活动明细  也就是先查询数据
     * @param id
     * @return
     */
    Activity queryActivityForDetail(String id);

}
