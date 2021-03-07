package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.constans.MyConstans;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.DicValueService;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

/**
 * @author 栗舜顺
 * 2020/12/14 0014
 */
@Controller
public class TransactionController {

    @Autowired
    private UserService userService;

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ContactsService contactsService;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private TranService tranService;

    @Autowired
    private TranRemarkService tranRemarkService;

    @Autowired
    private TranHistoryService tranHistoryService;



    @RequestMapping("/workbench/transaction/toIndex.do")
    public String toIndex(HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> typeList = dicValueService.queryDicValueByTypeCode("transactionType");

        request.setAttribute("userList", userList);
        request.setAttribute("stageList", stageList);
        request.setAttribute("sourceList", sourceList);
        request.setAttribute("typeList", typeList);

        return "workbench/transaction/index";
    }

    @RequestMapping("/workbench/transaction/toSave.do")
    public String toSave(HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> typeList = dicValueService.queryDicValueByTypeCode("transactionType");

        request.setAttribute("userList", userList);
        request.setAttribute("stageList", stageList);
        request.setAttribute("sourceList", sourceList);
        request.setAttribute("typeList", typeList);
        return "workbench/transaction/save";
    }

    @RequestMapping("/workbench/transaction/getActivityByName.do")
    @ResponseBody
    public Object getActivityByName(String name){
        List<Activity> activityList=activityService.queryActivityForDetailByName(name);
        return activityList;
    }

    @RequestMapping("/workbench/transaction/getContactsByName.do")
    @ResponseBody
    public Object getContactsByName(String name){
        List<Contacts> contactsList = contactsService.queryContactsByLikeName(name);
        return contactsList;
    }

    @RequestMapping("/workbench/transaction/getPossibility.do")
    @ResponseBody
    public Object getPossibility(String stage){
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(stage);
        return possibility;
    }

    @RequestMapping("/workbench/transaction/getCustomerName.do")
    @ResponseBody
    public Object getCustomerName(String name){
        List<Customer> customerList = customerService.queryCustomerForBlurName(name);
        return customerList;
    }

    @RequestMapping("/workbench/transaction/saveCreateTran.do")
    @ResponseBody
    public Object saveCreateTran(@RequestParam Map<String,Object> map, HttpSession session){
        User user= (User) session.getAttribute(MyConstans.USER);
        map.put(MyConstans.USER, user);
        try {
            int rows = tranService.saveCreateTran(map);
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

    @RequestMapping("/workbench/transaction/queryTranForDetailById.do")
    public String queryTranForDetailById(String id, Model model){
        //根据ID获取交易的信息
        Tran tran=tranService.queryTranForDetailById(id);
        String stage = tran.getStage();
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(stage);
        model.addAttribute("possibility", possibility);

        //根据ID获取交易备注信息
       List<TranRemark> remarkList=tranRemarkService.queryTranRemarkForDetailByTranId(id);

       //根据ID查询交易历史
        List<TranHistory> tranHistoryList=tranHistoryService.queryTranHistoryForDetailByTranId(id);

        //查询所有的stage并根据orders_no排序
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        model.addAttribute("stageList", stageList);


        model.addAttribute("tran", tran);
        model.addAttribute("remarkList", remarkList);
        model.addAttribute("tranHistoryList", tranHistoryList);

        return "workbench/transaction/detail";
    }




}
