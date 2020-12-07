package com.bjpowernode.crm.settings.service;

import com.bjpowernode.crm.settings.domain.DicValue;

import java.util.List;

/**
 * @author 栗舜顺
 * 2020/11/24 0024
 */
public interface DicValueService {

    List<DicValue> queryDicValueByTypeCode(String typeCode);

}
