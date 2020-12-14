package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.DicValueService;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.ContactsService;
import com.bjpowernode.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.ResourceBundle;

/**
 * @author 栗舜顺
 * 2020/12/14 0014
 */
@Controller
public class TranSactionController {

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



}
