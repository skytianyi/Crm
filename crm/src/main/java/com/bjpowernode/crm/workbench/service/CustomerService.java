package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

/**
 * @author 栗舜顺
 * 2020/11/28 0028
 */
public interface CustomerService {


    List<Customer> queryCustomerByConditionForPage(Map<String,Object> map);

    int queryCountCustomerByCondition(Map<String,Object> map);

    int saveCreateCustomerSelective(Customer customer);

    Customer queryCustomerById(String id);

    int updateCustomer(Customer customer);


    int deleteCustomerByIds(String[] ids);



}
