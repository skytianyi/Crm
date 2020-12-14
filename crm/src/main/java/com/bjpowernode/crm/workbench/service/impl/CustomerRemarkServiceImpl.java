package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.CustomerRemark;
import com.bjpowernode.crm.workbench.mapper.CustomerRemarkMapper;
import com.bjpowernode.crm.workbench.service.CustomerRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author 栗舜顺
 * 2020/12/10 0010
 */
@Service
public class CustomerRemarkServiceImpl implements CustomerRemarkService {

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    @Override
    public List<CustomerRemark> queryCustomerRemarkByCustomerId(String customerId) {
        return customerRemarkMapper.selectCustomerRemarkByCustomerId(customerId);
    }

    @Override
    public int saveCustomerRemark(CustomerRemark customerRemark) {
        return customerRemarkMapper.insertCustomerRemark(customerRemark);
    }

    @Override
    public int updateCustomerRemark(CustomerRemark customerRemark) {
        return customerRemarkMapper.updateCustomerRemark(customerRemark);
    }

    @Override
    public int deleteCustomerRemarkById(String id) {
        return customerRemarkMapper.deleteCustomerRemarkById(id);
    }

}
