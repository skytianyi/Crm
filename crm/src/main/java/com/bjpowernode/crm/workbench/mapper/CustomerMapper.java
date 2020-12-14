package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerMapper {
    int deleteByPrimaryKey(String id);

    int insert(Customer record);


    Customer selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Customer record);


    /**
     * 根据查询条件查询符合条件的客户
     * @param map
     * @return
     */
    List<Customer> selectCustomerByConditionForPage(Map<String,Object> map);

    /**
     * 根据查询条件查询符合条件的客户总条数
     * @param map
     * @return
     */
    int selectCountCustomerByCondition(Map<String,Object> map);

    /**
     * 添加客户
     * @param customer
     * @return
     */
    int insertCustomerSelective(Customer customer);

    /**
     * 根据id查询客户
     * @param id
     * @return
     */
    Customer selectCustomerById(String id);

    /**
     * 更新客户
     * @param customer
     * @return
     */
    int updateCustomer(Customer customer);

    /**
     * 根据IDS删除客户
     * @param ids
     * @return
     */
    int deleteCustomerByIds(String[] ids);

    /**
     * 根据ID查询客户的详细信息
     * @param id
     * @return
     */
    Customer selectCustomerForDetailById(String id);

    /**
     * 根据名称模糊查询客户信息
     * @param name
     * @return
     */
    List<Customer> selectCustomerForBlurName(String name);




}