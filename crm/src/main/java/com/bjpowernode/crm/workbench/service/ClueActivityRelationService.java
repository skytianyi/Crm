package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

/**
 * @author 栗舜顺
 * 2020/12/10 0010
 */
public interface ClueActivityRelationService {

    int saveClueActivityRelationByList(List<ClueActivityRelation> relationList);

    int deleteClueActivityRelationByClueIdAndActivityId(ClueActivityRelation car);



}
