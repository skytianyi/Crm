package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

/**
 * @author 栗舜顺
 * 2020/11/8 0008
 */

public interface UserService {


    User queryUserByLoginActAndLoginPwd(Map<String, Object> map);

    List<User> queryAllUsers();
}
