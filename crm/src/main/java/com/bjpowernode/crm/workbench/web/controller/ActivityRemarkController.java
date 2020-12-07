package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.constans.MyConstans;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.util.DateTimeUtil;
import com.bjpowernode.crm.commons.util.UUIDUtil;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

/**
 * @author 栗舜顺
 * 2020/11/23 0023
 */
@Controller
public class ActivityRemarkController {

    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/saveCreateActivityRemark.do")
    @ResponseBody
    public Object saveCreateActivityRemark(ActivityRemark activityRemark, HttpSession session){
        User user= (User) session.getAttribute(MyConstans.USER);
        activityRemark.setId(UUIDUtil.getUUID());
        activityRemark.setCreateTime(DateTimeUtil.getFormatDateTime(new Date()));
        activityRemark.setCreateBy(user.getId());
        activityRemark.setEditFlag(MyConstans.REMARK_EDIT_FLAG_NOT);
        try {
            int rows = activityRemarkService.saveCreateActivityRemark(activityRemark);
            if(rows>0){
                return ReturnObject.success(activityRemark);
            }else {
                return ReturnObject.error("系统繁忙,请稍候重试");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ReturnObject.error("系统繁忙,请稍候重试");
        }

    }

    @RequestMapping("/workbench/activity/deleteActivityRemark.do")
    @ResponseBody
    public Object deleteActivityRemark(String id){
        try {
            int rows = activityRemarkService.deleteActivityRemarkById(id);
            if(rows>0){
                return ReturnObject.success();
            }else {
                return ReturnObject.error("系统繁忙,请稍候重试");
            }
        } catch (Exception e) {
            return ReturnObject.error("系统繁忙,请稍候重试");
        }
    }

    @RequestMapping("/workbench/activity/updateActivityRemark.do")
    @ResponseBody
    public Object updateActivityRemark(ActivityRemark activityRemark,HttpSession session){
        User user= (User) session.getAttribute(MyConstans.USER);
        activityRemark.setEditBy(user.getId());
        activityRemark.setEditTime(DateTimeUtil.getFormatDateTime(new Date()));
        activityRemark.setEditFlag(MyConstans.REMARK_EDIT_FLAG_YES);
        try {
            int rows = activityRemarkService.updateActivityRemark(activityRemark);
            if(rows>0){
                return ReturnObject.success(activityRemark);
            }else {
                return ReturnObject.error("系统繁忙,请稍候重试");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ReturnObject.error("系统繁忙,请稍候重试");
        }
    }


}
