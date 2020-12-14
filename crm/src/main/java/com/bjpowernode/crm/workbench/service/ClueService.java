package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

/**
 * @author 栗舜顺
 * 2020/11/26 0026
 */
public interface ClueService {

    List<Clue> queryClueByCondition(Map<String,Object> map);

    int queryCountClueByCondition(Map<String,Object> map);

    int saveCreateClue(Clue clue);

    int updateClueById(Clue clue);

    Clue queryClueById(String id);

    int deleteClueByIds(String[] ids);

    Clue queryClueForDetailById(String id);

    void saveConvertClue(Map<String,Object> map);


}
