package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.CustomerRemark;

import java.util.List;

/**
 * @author 栗舜顺
 * 2020/12/10 0010
 */
public interface CustomerRemarkService {

    List<CustomerRemark> queryCustomerRemarkByCustomerId(String customerId);

    int saveCustomerRemark(CustomerRemark customerRemark);

    int  updateCustomerRemark(CustomerRemark customerRemark);

    int deleteCustomerRemarkById(String id);



}
