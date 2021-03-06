package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.commons.constans.MyConstans;
import com.bjpowernode.crm.commons.domain.ReturnObject;
import com.bjpowernode.crm.commons.util.DateTimeUtil;
import com.bjpowernode.crm.commons.util.UUIDUtil;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.CustomerRemark;
import com.bjpowernode.crm.workbench.service.CustomerRemarkService;
import com.bjpowernode.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author 栗舜顺
 * 2020/11/28 0028
 */
@Controller
public class CustomerController {

    @Autowired
    private UserService userService;

    @Autowired
    private CustomerService customerService;

    @Autowired
    private CustomerRemarkService customerRemarkService;

    @RequestMapping("/workbench/customer/toIndex.do")
    public String toIndex(HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        request.setAttribute("userList", userList);

        return "workbench/customer/index";
    }

    @RequestMapping("/workbench/customer/queryCustomerByCondition.do")
    @ResponseBody
    public Object queryCustomerByCondition(String name,String owner,String phone,String website,int pageNo,int pageSize){
        Map<String,Object> map=new HashMap<>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("phone", phone);
        map.put("website", website);
        int beginNo=(pageNo-1)*pageSize;
        map.put("beginNo", beginNo);
        map.put("pageSize", pageSize);

        List<Customer> customerList = customerService.queryCustomerByConditionForPage(map);
        int totalRows = customerService.queryCountCustomerByCondition(map);

        Map<String,Object> retMap=new HashMap<>();
        retMap.put("customerList", customerList);
        retMap.put("totalRows", totalRows);

        return retMap;
    }

    @RequestMapping("/workbench/customer/saveCreateCustomer.do")
    @ResponseBody
    public Object saveCreateCustomer(Customer customer, HttpSession session){
        User user= (User) session.getAttribute(MyConstans.USER);
        customer.setId(UUIDUtil.getUUID());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateTimeUtil.getFormatDateTime(new Date()));

        try {
            int rows = customerService.saveCreateCustomerSelective(customer);
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

    @RequestMapping("/workbench/customer/queryCustomerById.do")
    @ResponseBody
    public Object queryCustomerById(String id) {

        Customer customer = customerService.queryCustomerById(id);
        return customer;
    }

    @RequestMapping("/workbench/customer/updateCustomer.do")
    @ResponseBody
    public Object updateCustomer(Customer customer,HttpSession session){
        User user= (User) session.getAttribute(MyConstans.USER);
        customer.setEditBy(user.getId());
        customer.setEditTime(DateTimeUtil.getFormatDateTime(new Date()));

        try {
            int rows = customerService.updateCustomer(customer);
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

    @RequestMapping("/workbench/customer/deleteCustomerByIds.do")
    @ResponseBody
    public Object deleteCustomerByIds(String[] ids){
        try {
            int rows = customerService.deleteCustomerByIds(ids);
            if(rows>0){
                return ReturnObject.success();
            }else {
                return ReturnObject.error("系统异常,请稍候重试");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ReturnObject.error("系统异常,请稍候重试");
        }
    }

    @RequestMapping("/workbench/customer/detailCustomer.do")
    public String detailCustomer(String id,HttpServletRequest request){
        Customer customer = customerService.queryCustomerForDetailById(id);
        request.setAttribute("customer", customer);
        return "workbench/customer/detail";
    }

    @RequestMapping("/workbench/customer/getCustomerRemarkByCustomerId.do")
    @ResponseBody
    public Object getCustomerRemarkByCustomerId(String customerId){
        List<CustomerRemark> customerRemarkList = customerRemarkService.queryCustomerRemarkByCustomerId(customerId);
        return customerRemarkList;
    }

    @RequestMapping("/workbench/customer/saveCustomerRemark.do")
    @ResponseBody
    public Object saveCustomerRemark(CustomerRemark customerRemark,HttpSession session){
        User user= (User) session.getAttribute(MyConstans.USER);
        customerRemark.setId(UUIDUtil.getUUID());
        customerRemark.setCreateBy(user.getId());
        customerRemark.setCreateTime(DateTimeUtil.getFormatDateTime(new Date()));
        customerRemark.setEditFlag(MyConstans.REMARK_EDIT_FLAG_NOT);
        try {
            int rows = customerRemarkService.saveCustomerRemark(customerRemark);
            if(rows>0){
                return ReturnObject.success(customerRemark);
            }else {
                return ReturnObject.error("系统繁忙,请稍候重试");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ReturnObject.error("系统繁忙,请稍候重试");
        }
    }

    @RequestMapping("/workbench/customer/updateCustomerRemark.do")
    @ResponseBody
    public Object updateCustomerRemark(CustomerRemark customerRemark,HttpSession session){
        User user= (User) session.getAttribute(MyConstans.USER);
        customerRemark.setEditFlag(MyConstans.REMARK_EDIT_FLAG_YES);
        customerRemark.setEditBy(user.getId());
        customerRemark.setEditTime(DateTimeUtil.getFormatDateTime(new Date()));

        try {
            int rows = customerRemarkService.updateCustomerRemark(customerRemark);
            if(rows>0){
                return ReturnObject.success(customerRemark);
            }else {
                return ReturnObject.error("系统繁忙,请稍候重试");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ReturnObject.error("系统繁忙,请稍候重试");
        }
    }

    @RequestMapping("/workbench/customer/deleteCustomerRemark.do")
    @ResponseBody
    public Object deleteCustomerRemark(String id){
        try {
            int rows = customerRemarkService.deleteCustomerRemarkById(id);
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






}
