package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;

/**
 * @author 栗舜顺
 * 2020/12/2 0002
 */
public interface ClueRemarkService {

    List<ClueRemark> queryClueRemarkForDetailByClueId(String clueId);

    int saveCreateClueRemark(ClueRemark clueRemark);

    int deleteClueRemarkById(String id);

    int updateClueRemark(ClueRemark clueRemark);




}
