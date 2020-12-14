package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Contacts;

import java.util.List;

/**
 * @author 栗舜顺
 * 2020/12/14 0014
 */
public interface ContactsService {

    List<Contacts> queryContactsByLikeName(String name);

}
