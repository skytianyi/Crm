package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.settings.domain.DicValue;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.DicValueService;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * @author 栗舜顺
 * 2020/12/11 0011
 */
@Controller
public class ContactsController {

    @Autowired
    private UserService userService;

    @Autowired
    private DicValueService dicValueService;

    @Autowired
    private CustomerService customerService;


    @RequestMapping("/workbench/contacts/toIndex.do")
    public String toIndex(HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        //返回称呼
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");

        request.setAttribute("userList", userList);
        request.setAttribute("appellationList", appellationList);
        request.setAttribute("sourceList", sourceList);

        return "workbench/contacts/index";
    }

    @RequestMapping("/workbench/contacts/getCustomerName.do")
    @ResponseBody
    public Object getCustomerName(String name){

        List<Customer> customerList = customerService.queryCustomerForBlurName(name);
        if(customerList!=null){
            return ReturnObject.success(customerList);
        }else {
            return ReturnObject.error("无数据");
        }
    }
}
