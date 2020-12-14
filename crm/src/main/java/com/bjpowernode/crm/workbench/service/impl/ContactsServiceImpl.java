package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.mapper.ContactsMapper;
import com.bjpowernode.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author 栗舜顺
 * 2020/12/14 0014
 */
@Service
public class ContactsServiceImpl implements ContactsService {

    @Autowired
    private ContactsMapper contactsMapper;

    @Override
    public List<Contacts> queryContactsByLikeName(String name) {
        return contactsMapper.selectContactsByLikeName(name);
    }
}
