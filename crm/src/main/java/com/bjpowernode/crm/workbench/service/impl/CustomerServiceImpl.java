package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.mapper.CustomerMapper;
import com.bjpowernode.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author 栗舜顺
 * 2020/11/28 0028
 */
@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerMapper customerMapper;


    @Override
    public List<Customer> queryCustomerByConditionForPage(Map<String, Object> map) {
        return customerMapper.selectCustomerByConditionForPage(map);
    }

    @Override
    public int queryCountCustomerByCondition(Map<String, Object> map) {
        return customerMapper.selectCountCustomerByCondition(map);
    }

    @Override
    public int saveCreateCustomerSelective(Customer customer) {
        return customerMapper.insertCustomerSelective(customer);
    }

    @Override
    public Customer queryCustomerById(String id) {
        return customerMapper.selectCustomerById(id);
    }

    @Override
    public int updateCustomer(Customer customer) {
        return customerMapper.updateCustomer(customer);
    }

    @Override
    public int deleteCustomerByIds(String[] ids) {
        return customerMapper.deleteCustomerByIds(ids);
    }

    @Override
    public Customer queryCustomerForDetailById(String id) {
        return customerMapper.selectCustomerForDetailById(id);
    }

    @Override
    public List<Customer> queryCustomerForBlurName(String name) {
        return customerMapper.selectCustomerForBlurName(name);
    }
}
