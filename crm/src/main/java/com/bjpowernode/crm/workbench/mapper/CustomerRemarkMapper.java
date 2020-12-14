package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(CustomerRemark record);

    int insertSelective(CustomerRemark record);

    CustomerRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(CustomerRemark record);

    int updateByPrimaryKey(CustomerRemark record);

    /**
     * 根据客户ID查询客户备注
     * @param customerId
     * @return
     */
    List<CustomerRemark> selectCustomerRemarkByCustomerId(String customerId);


    /**
     * 添加客户备注
     * @param customerRemark
     * @return
     */
    int insertCustomerRemark(CustomerRemark customerRemark);

    /**
     * 根据ID更改客户备注信息
     * @param customerRemark
     * @return
     */
    int  updateCustomerRemark(CustomerRemark customerRemark);

    /**
     * 根据ID删除客户备注信息
     * @param id
     * @return
     */
    int deleteCustomerRemarkById(String id);

    /**
     * 批量添加客户备注信息
     * @param crList
     * @return
     */
    int insertCustomerRemarkByList(List<CustomerRemark> crList);



}