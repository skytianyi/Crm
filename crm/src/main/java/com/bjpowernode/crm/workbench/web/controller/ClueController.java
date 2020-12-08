package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.constans.MyConstans;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.util.DateTimeUtil;
import com.bjpowernode.crm.commons.util.UUIDUtil;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.DicValueService;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.ClueRemarkService;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.omg.CORBA.OBJ_ADAPTER;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * @author 栗舜顺
 * 2020/11/24 0024
 */
@Controller
public class ClueController {

    @Autowired
    private UserService userService;

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private ClueService clueService;

    @Autowired
    private ClueRemarkService clueRemarkService;

    @Autowired
    private ActivityService activityService;

    @RequestMapping("/workbench/clue/toIndex.do")
    public String toIndex(HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        //返回称呼
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        List<DicValue> clueStateList = dicValueService.queryDicValueByTypeCode("clueState");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");

        request.setAttribute("userList", userList);
        request.setAttribute("appellationList", appellationList);
        request.setAttribute("clueStateList", clueStateList);
        request.setAttribute("sourceList", sourceList);
        return "workbench/clue/index";
    }

    @RequestMapping("/workbench/clue/queryClueByCondition.do")
    @ResponseBody
    public Object queryClueByCondition(@RequestParam Map<String,Object> map){
        String pageNoStr = (String) map.get("pageNo");
        Integer pageNo = Integer.valueOf(pageNoStr);
        String pageSizeStr = (String) map.get("pageSize");
        Integer pageSize=Integer.valueOf(pageSizeStr);

        Integer beginNo = (pageNo - 1) * pageSize;
        map.put("beginNo", beginNo);
        map.put("pageSize", pageSize);
        List<Clue> clueList = clueService.queryClueByCondition(map);
        int totalRows = clueService.queryCountClueByCondition(map);

        Map<String,Object> retMap=new HashMap<>();
        retMap.put("clueList", clueList);
        retMap.put("totalRows",totalRows );

        return retMap;
    }

    @RequestMapping("/workbench/clue/saveCreateClue.do")
    @ResponseBody
    public Object saveCreateClue(Clue clue, HttpSession session){
        User user= (User) session.getAttribute(MyConstans.USER);
        clue.setId(UUIDUtil.getUUID());
        clue.setCreateBy(user.getId());
        clue.setCreateTime(DateTimeUtil.getFormatDateTime(new Date()));

        try {
            int rows = clueService.saveCreateClue(clue);
            if(rows>0){
                return ReturnObject.success();
            }else {
                return ReturnObject.error("系统繁忙,请稍候重试");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ReturnObject.error("系统繁忙,请稍候重试");
        }
    }

    @RequestMapping("/workbench/clue/queryClueById.do")
    @ResponseBody
    public Object queryClueById(String id){
        Clue clue = clueService.queryClueById(id);

        return ReturnObject.success(clue);
    }

    @RequestMapping("/workbench/clue/updateClue.do")
    @ResponseBody
    public Object updateClue(Clue clue,HttpSession session){
        User user= (User) session.getAttribute(MyConstans.USER);

        clue.setEditBy(user.getId());
        clue.setEditTime(DateTimeUtil.getFormatDateTime(new Date()));

        try {
            int rows = clueService.updateClueById(clue);
            if(rows>0){
                return ReturnObject.success();
            }else {
                return ReturnObject.error("系统繁忙,请稍候重试");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ReturnObject.error("系统繁忙,请稍候重试");
        }

    }

    @RequestMapping("/workbench/clue/deleteClue.do")
    @ResponseBody
    public Object deleteClue(String[] ids){
        try {
            int rows = clueService.deleteClueByIds(ids);
            if(rows>0){
                return ReturnObject.success();
            }else {
                return ReturnObject.error("系统繁忙,请稍候重试");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ReturnObject.error("系统繁忙,请稍候重试");
        }
    }

    @RequestMapping("/workbench/clue/detailClue.do")
    public ModelAndView detailClue(String id){
        Clue clue = clueService.queryClueForDetailById(id);
        List<ClueRemark> clueRemarkList = clueRemarkService.queryClueRemarkForDetailByClueId(id);
        List<Activity> activityList = activityService.queryActivityForDetailByClueId(id);
        ModelAndView mv=new ModelAndView();
        mv.addObject("clue",clue);
        mv.addObject("activityList",activityList);
        mv.addObject("clueRemarkList",clueRemarkList);
        mv.setViewName("workbench/clue/detail");
        return mv;
    }

    @RequestMapping("/workbench/clue/saveCreateClueRemark.do")
    @ResponseBody
    public Object saveCreateClueRemark(ClueRemark clueRemark,HttpSession session){
       User user= (User) session.getAttribute(MyConstans.USER);
        clueRemark.setId(UUIDUtil.getUUID());
        clueRemark.setCreateBy(user.getId());
        clueRemark.setCreateTime(DateTimeUtil.getFormatDateTime(new Date()));
        clueRemark.setEditFlag(MyConstans.REMARK_EDIT_FLAG_NOT);
        try {
            int rows = clueRemarkService.saveCreateClueRemark(clueRemark);
            if(rows>0){
                return ReturnObject.success(clueRemark);
            }else {
                return ReturnObject.error("系统繁忙,请稍候重试");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ReturnObject.error("系统繁忙,请稍候重试");
        }
    }

    @RequestMapping("/workbench/clue/deleteClueRemark.do")
    @ResponseBody
    public Object deleteClueRemark(String id){
        try {
            int rows = clueRemarkService.deleteClueRemarkById(id);
            if(rows>0){
                return ReturnObject.success();
            }else {
                return ReturnObject.error("系统繁忙,请稍候重试");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ReturnObject.error("系统繁忙,请稍候重试");
        }
    }

    @RequestMapping("/workbench/clue/updateClueRemark.do")
    @ResponseBody
    public Object updateClueRemark(ClueRemark clueRemark,HttpSession session){
        User user= (User) session.getAttribute(MyConstans.USER);
        clueRemark.setEditFlag(MyConstans.REMARK_EDIT_FLAG_YES);
        clueRemark.setEditBy(user.getId());
        clueRemark.setEditTime(DateTimeUtil.getFormatDateTime(new Date()));

        try {
            int rows = clueRemarkService.updateClueRemark(clueRemark);
            if(rows>0){
                return ReturnObject.success(clueRemark);
            }else {
                return ReturnObject.error("系统繁忙,请稍候重试");

            }
        } catch (Exception e) {
            e.printStackTrace();
            return ReturnObject.error("系统繁忙,请稍候重试");
        }
    }

    @RequestMapping("/workbench/clue/queryActivityForDetailByNameClueId.do")
    @ResponseBody
    public Object queryActivityForDetailByNameClueId(String name,String clueId){
        Map<String,Object> map=new HashMap<>();
        map.put("name", name);
        map.put("clueId", clueId);
        List<Activity> activityList = activityService.queryActivityForDetailByNameClueId(map);
        return activityList;
    }
}
