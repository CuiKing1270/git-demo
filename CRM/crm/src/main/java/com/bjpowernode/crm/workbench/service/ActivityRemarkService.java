package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.pojo.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {
    List<com.bjpowernode.crm.workbench.pojo.ActivityRemark> queryActivityRemarkForDetailByActivityId(String ActivityId);

    int saveActivityRemark(ActivityRemark remark);
    int deleteActivityRemarkById(String id);
    int saveEditActivityRemark(ActivityRemark remark);

}
