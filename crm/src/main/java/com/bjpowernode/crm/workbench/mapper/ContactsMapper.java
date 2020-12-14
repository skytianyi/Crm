package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsMapper {
    int deleteByPrimaryKey(String id);

    int insert(Contacts record);

    int insertSelective(Contacts record);

    Contacts selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Contacts record);

    int updateByPrimaryKey(Contacts record);

    /**
     * 根据名称模糊查询符合条件的联系人
     * @param name
     * @return
     */
    List<Contacts> selectContactsByLikeName(String name);
}